import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/utilities/datetime_exts.dart';
import 'package:veloplan/widgets/timeline_item.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';

/// Displays the summary of journey screen.
///
/// Presents the chosen docking stations and destinations by the user,
/// distances and durations in their [itinerary], and a code for people to create a group.
/// Author(s): Nicole, Marija, Liliana, Hristina
class SummaryJourneyScreen extends StatefulWidget {
  late Itinerary itinerary;
  bool cameFromSchedule;
  var _itineraryManager;

  final DatabaseManager _databaseManager = DatabaseManager();
  SummaryJourneyScreen(this.itinerary, this.cameFromSchedule, {Key? key})
      : super(key: key) {
    _itineraryManager = ItineraryManager(itinerary);
  }

  @override
  State<StatefulWidget> createState() => SummaryJourneyScreenState(
      _itineraryManager,
      this.cameFromSchedule,
      this._databaseManager,
      groupManager(this._databaseManager));
}

class SummaryJourneyScreenState extends State<SummaryJourneyScreen> {
  bool cameFromSchedule;
  bool isInGroup = false;
  final DatabaseManager _databaseManager;
  late ItineraryManager _itineraryManager;
  final groupManager _groupManager;
  late String groupID = "";
  late String organiser = "";
  late List<List<double?>?> pointsInDoubles;
  late List<LatLng> pointsCoord;
  late Itinerary _itinerary;
  late List<Path> paths;
  late Future<List<Path>> pathsFuture;

  SummaryJourneyScreenState(this._itineraryManager, this.cameFromSchedule,
      this._databaseManager, this._groupManager) {
    _itinerary = _itineraryManager.getItinerary();
  }

  @override
  void initState() {
    pointsInDoubles = convertDocksToDouble(widget.itinerary.docks!)!;
    _setData();
    // pathsFuture = _loadPaths();
    super.initState();
  }

  /// Returns user's group.
  Future<String> _getGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    if (user.data() != null) {
      groupID = user.data()!['group'];
      return user.data()!['group'];
    }
    return "";
  }

  _setData() async {
    var owner;
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    if (user.data() != null) {
      var hasGroup = user.data()!.keys.contains('group');
      if (hasGroup) {
        var group = await _databaseManager.getByEquality(
            'group', 'code', user.data()!['group']);
        owner = await _groupManager.getGroupOwnerRef(group);
        pointsInDoubles = [];
      }
      setState(() {
        isInGroup = hasGroup;
        organiser = user.data()!['username'];
        if (isInGroup && !cameFromSchedule) {
          organiser = owner.data()!['username'];
        }
      });
    }
  }

  @visibleForTesting
  Future<void> createGroup() async {
    await _groupManager.createGroup(_itinerary);
    setState(() {
      isInGroup = true;
    });
  }

  Future<void> leaveGroup() async {
    var userID = _databaseManager.getCurrentUser()?.uid;
    var user = await _databaseManager.getByKey('users', userID!);
    if (user.data() != null) {
      groupID = user.data()!['group'];

      var ownerID = await _groupManager.leaveGroup(groupID);

      if (ownerID == _databaseManager.getCurrentUser()?.uid) {
      } else {
        Navigator.pop(context);
      }

      setState(() {
        isInGroup = false;
        organiser = user.data()!['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Center(
              child: Image.asset('assets/images/summary_journey.png',
                  height: 140.0)),
          _buildOrganiser(),
          if (isInGroup)
            if (!cameFromSchedule)
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  color: CustomColors.lighterOrange,
                  child: FutureBuilder<String>(
                      future: _getGroup(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            child: SelectableText(
                              "Tap here to copy the code: " + groupID,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: groupID),
                              );
                            },
                          );
                        } else {
                          return Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      })),
          if (!isInGroup)
            if (!cameFromSchedule)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Share Journey'),
                    onPressed: () {
                      createGroup();
                    },
                  ),
                ],
              ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text('Planned Stops',
                style: Theme.of(context).textTheme.headline1),
          ),
          const SizedBox(height: 15),
          Container(
            child: FutureBuilder<List<Path>>(
              future: _loadPaths(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
                    children: _generateStops(),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isInGroup && !cameFromSchedule)
                ElevatedButton(
                  child: const Text('Leave Group'),
                  onPressed: () {
                    leaveGroup();
                  },
                ),
              SizedBox(width: 10.0),
              if (_itinerary.date != null &&
                  DateTime.now().isSameDate(_itinerary.date!))
                ElevatedButton(
                  child: const Text('Start Journey'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapRoutePage(_itinerary)),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
      appBar: AppBar(
        title: const Text('Summary of Journey'),
      ),
    );
  }

  /// Generates timeline items for the planned stops.
  List<Widget> _generateStops() {
    List<Widget> stops = [];
    if (_itinerary.docks != null) {
      for (int i = 0; i < _itinerary.docks!.length; i++) {
        stops.add(
          TimelineItem(
            first: i == 0 ? true : false,
            last: i == _itinerary.docks!.length - 1 ? true : false,
            content: _itinerary.docks![i].name,
            destination: _itinerary.myDestinations![i].toString(),
            duration: paths[i + 1].duration,
            distance: paths[i + 1].distance,
          ),
        );
      }
    }
    return stops;
  }

  /// Creates the container for organiser.
  Widget _buildOrganiser() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.lighterGreen,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '${organiser}',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(
                  'Organiser',
                  style: CustomTextStyles.organiserSubtitleText,
                ),
              ],
            ),
            Image.asset('assets/images/crown.png', height: 32),
          ],
        ),
      ),
    );
  }

  /// Returns [paths] from user's [itinerary].
  Future<List<Path>> _loadPaths() async {
    paths = await _itineraryManager.setJourney();
    return paths;
  }
}
