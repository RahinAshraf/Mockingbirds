import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
// import 'package:timeline_tile/timeline_tile.dart';
import 'package:timelines/timelines.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/navbar.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';

/// Displays the summary of journey screen.
///
/// Presents the chosen docking stations and destinations by the user,
/// distances and durations in their [itinerary], and a code for people to create a group.
/// Author(s): Nicole, Marija, Liliana, Hristina
class SummaryJourneyScreen extends StatefulWidget {
  late Itinerary itinerary;
  bool cameFromSchedule;
  final DatabaseManager _databaseManager = DatabaseManager();
  SummaryJourneyScreen(this.itinerary, this.cameFromSchedule, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SummaryJourneyScreenState(
      this.itinerary, this.cameFromSchedule, this._databaseManager);
}

class SummaryJourneyScreenState extends State<SummaryJourneyScreen> {
  bool cameFromSchedule;
  bool isInGroup = false;
  late String groupID = "";
  late String organiser = "";
  late List<List<double?>?> pointsInDoubles;
  late List<LatLng> pointsCoord;
  late Itinerary _itinerary;
  final DatabaseManager _databaseManager;
  late List<Path> paths;
  late ItineraryManager _itineraryManager;

  SummaryJourneyScreenState(
      this._itinerary, this.cameFromSchedule, this._databaseManager) {
    _itineraryManager = ItineraryManager(_itinerary);
  }

  @override
  void initState() {
    pointsInDoubles = convertDocksToDouble(widget.itinerary.docks!)!;
    _setData();
    super.initState();
  }

  /// Returns [paths] from user's [itinerary].
  Future<List<Path>> _loadPaths() async {
    paths = await _itineraryManager.setJourney();
    return paths;
  }

  /// Returns user's group.
  Future<String> _getGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    groupID = user.data()!['group'];
    return user.data()!['group'];
  }

  _setData() async {
    var res;
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var hasGroup = user.data()!.keys.contains('group');
    if (hasGroup) {
      var group = await _databaseManager.getByEquality(
          'group', 'code', user.data()!['group']);
      res = await _getGroupOwner(group);
      pointsInDoubles = [];
    }
    setState(() {
      isInGroup = hasGroup;
      organiser = user.data()!['username'];
      if (isInGroup && !cameFromSchedule) {
        organiser = res.data()!['username'];
      }
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getGroupOwner(
      QuerySnapshot<Map<String, dynamic>> group) {
    var tempr;
    group.docs.forEach((element) {
      tempr = _databaseManager.getByKey('users', element.data()['ownerID']);
    });
    return tempr;
  }

  String _padWithZeroes(String textToPad) {
    while (textToPad.length < 6) {
      textToPad = '0' + textToPad;
    }
    return textToPad;
  }

  @visibleForTesting
  void createGroup() async {
    var ownerID = _databaseManager.getCurrentUser()?.uid;
    List list = [];
    list.add(ownerID);
    math.Random rng = math.Random();
    String code = rng.nextInt(999999).toString();
    code = _padWithZeroes(code);
    var x = await _databaseManager.getByEquality('group', 'code', code);
    while (x.size != 0) {
      code = rng.nextInt(999999).toString();
      code = _padWithZeroes(code);

      x = await _databaseManager.getByEquality('group', 'code', code);
    }
    List<GeoPoint> geoList = [];
    var destinationsIndouble =
        convertLatLngToDouble(_itinerary.myDestinations!);
    for (int i = 0; i < destinationsIndouble!.length; i++) {
      geoList.add(
          GeoPoint(destinationsIndouble[i]![0]!, destinationsIndouble[i]![1]!));
    }

    try {
      await _databaseManager.setByKey(
          'users', ownerID!, {'group': code}, SetOptions(merge: true));
      var group = await _databaseManager.addToCollection('group', {
        'code': code,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      var journey = await group.collection("itinerary").add({
        'journeyID': _itinerary.journeyDocumentId,
        'points': geoList,
        'date': _itinerary.date,
        'numberOfCyclists': _itinerary.numberOfCyclists
      });
      var dockingStationList = _itinerary.docks!;
      for (int j = 0; j < geoList.length; j++) {
        var geo = geoList[j];
        journey.collection("coordinates").add({
          'coordinate': geo,
          'index': j,
        });
      }

      for (int i = 0; i < dockingStationList.length; i++) {
        var station = dockingStationList[i];
        journey.collection("dockingStations").add({
          'id': station.stationId,
          'name': station.name,
          'location': GeoPoint(station.lat, station.lon),
          'index': i,
        });
      }

      setState(() {
        isInGroup = true;
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred';

      if (err.message != null) {
        message = err.message!;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  _leaveGroup() async {
    try {
      var temp = await _databaseManager.getByEquality('group', 'code', groupID);
      var userID = _databaseManager.getCurrentUser()?.uid;
      var ownerID;
      List list = [];
      bool wasDeleted = false;
      for (var element in temp.docs) {
        ownerID = element.data()['ownerID'];
        list = element.data()['memberList'];
        list.removeWhere((element) => (element == userID));
        if (list.isEmpty) {
          wasDeleted = true;
          element.reference.delete();
        } else {
          if (ownerID == userID) {
            _databaseManager
                .updateByKey('group', element.id, {'ownerID': list[0]});
          }
          _databaseManager
              .updateByKey('group', element.id, {'memberList': list});
        }
      }
      await _databaseManager
          .updateByKey('users', userID!, {'group': FieldValue.delete()});
      if (ownerID == _databaseManager.getCurrentUser()?.uid) {
      } else {
        context.push(NavBar());
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {}
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    setState(() {
      isInGroup = false;
      organiser = user.data()!['username'];
    });
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
                  padding: const EdgeInsets.all(10),
                  color: Theme.of(context).primaryColor,
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
            if (_itinerary.date?.day == DateTime.now().day &&
                _itinerary.date?.month == DateTime.now().month &&
                _itinerary.date?.year == DateTime.now().year)
              if (!cameFromSchedule)
                Container(
                    height: 100,
                    padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                    child: ElevatedButton(
                      child: const Text('Share journey'),
                      onPressed: () {
                        createGroup();
                      },
                    )),
          if (cameFromSchedule)
            Center(child: Text('You can\'t share prescheduled trips.')),
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text('Planned Stops',
                style: Theme.of(context).textTheme.headline1),
          ),
          const SizedBox(height: 20),
          Container(
            child: FutureBuilder<List<Path>>(
              future: _loadPaths(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    print('MARIJAA');
                    _itineraryManager.printPaths();
                    return Column(
                      // children: [Text('data ${paths}')],
                      children: _generateStops(),
                    );
                  } else {
                    return Text(
                        'Snapshot has error: ${snapshot.hasError}, and ${snapshot.data}.');
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isInGroup && !cameFromSchedule)
                ElevatedButton(
                  child: const Text('LEAVE GROUP'),
                  onPressed: () {
                    _leaveGroup();
                  },
                ),
              SizedBox(width: 10.0),
              if (_itinerary.date?.day == DateTime.now().day &&
                  _itinerary.date?.month == DateTime.now().month &&
                  _itinerary.date?.year == DateTime.now().year)
                ElevatedButton(
                  child: const Text('START JOURNEY'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapRoutePage(_itinerary)),
                    );
                  },
                ),
            ],
          )
        ],
      ),
      appBar: AppBar(
        title: const Text('Summary of Journey'),
      ),
    );
  }

  /// Creates the container for organiser.
  Widget _buildOrganiser() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0x8099D2A9),
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
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Text(
                  'Organiser',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            Image.asset('assets/images/crown.png', height: 32),
          ],
        ),
      ),
    );
  }

  /// Generates station cards for the stops.
  List<Widget> _generateStops() {
    List<Widget> stops = [];

    for (int i = 0; i < _itinerary.docks!.length; i++) {
      stops.add(
        TimelineItem(
          first: i == 0 ? true : false,
          last: i == _itinerary.docks!.length - 1 ? true : false,
          content: _itinerary.docks![i].name,
          duration: paths[i].duration,
          distance: paths[i].distance,
        ),
      );
    }
    return stops;
  }
}

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {this.first = false,
      this.last = false,
      required this.content,
      required this.duration,
      required this.distance});

  final bool first;
  final bool last;
  final String content;
  final double distance;
  final double duration;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: true,
      beforeLineStyle: const LineStyle(
        thickness: 1.0,
        color: Color(0XFFe1e1e1),
      ),
      indicatorStyle: const IndicatorStyle(
        padding: EdgeInsets.all(5),
        width: 10,
        indicatorXY: 0.0,
        color: Color(0xFF99D2A9),
      ),
      alignment: TimelineAlign.start,
      endChild: Column(
        children: [
          Text(
            content,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF99D2A9),
              fontWeight: FontWeight.bold,
            ),
          ),
          // Card(
          //   elevation: 1,
          //   // margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
          //   shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(15.0),
          //     bottomRight: Radius.circular(15.0),
          //     topRight: Radius.circular(15.0),
          //   )),
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: Expanded(
          //       child: Text(
          //         content,
          //         style: TextStyle(
          //           fontSize: 15.0,
          //           color: Color(0xFF99D2A9),
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Text('Dur: ${duration}'),
          Text('Dis: ${distance}'),
        ],
      ),
    );
  }
}
