import 'dart:developer';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/models/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../models/itinerary.dart';
import 'navigation/map_with_route_screen.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/navbar.dart';
import 'package:veloplan/utilities/dart_exts.dart';

/// Class useful to present the chosen docking stations and destinations by the user, distances and durations about their itinerary, a code for people to create a group
///Author(s): Nicole, Marija, Liliana, Hristina

class SummaryJourneyScreen extends StatefulWidget {
  late Itinerary itinerary;
  bool cameFromSchedule;
  var _itineraryManager;

  final DatabaseManager _databaseManager = DatabaseManager();
  SummaryJourneyScreen(this.itinerary,this.cameFromSchedule,{Key? key}) : super(key: key) {
    _itineraryManager = new ItineraryManager(itinerary);
  }

    @override
    State<StatefulWidget> createState() =>
        SummaryJourneyScreenState(_itineraryManager , this.cameFromSchedule, this._databaseManager, groupManager(this._databaseManager));




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
  final groupManager _groupManager;

  SummaryJourneyScreenState(this._itineraryManager, this.cameFromSchedule, this._databaseManager, this._groupManager) {
    paths = _itineraryManager.getPaths();
    _itinerary = _itineraryManager.getItinerary();
  }

  @override
  void initState() {
    pointsInDoubles = convertDocksToDouble(widget.itinerary.docks!)!;
    _setData();
    super.initState();
  }

  Future<String> _getGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    groupID = user.data()!['group'];
    return user.data()!['group'];
  }

  _setData() async {
    var owner;
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
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




  @visibleForTesting
  Future<void> createGroup() async {
    await _groupManager.createGroup(_itinerary);
    setState(() {
      isInGroup = true;
    });

  }

  Future<void> leaveGroup() async {
    var userID = _databaseManager.getCurrentUser()?.uid;
    var user = await _databaseManager.getByKey(
        'users',userID!);
    groupID = user.data()!['group'];

    var ownerID = await _groupManager.leaveGroup(groupID);

    if (ownerID == _databaseManager.getCurrentUser()?.uid) {
    } else {
      context.push(NavBar());
    }


    setState(() {
      isInGroup = false;
      organiser = user.data()!['username'];

    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Summary of Journey'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              key: Key("back"),
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                      child: Image.asset('assets/images/summary_journey.png'))),
              Container(
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                  child: ElevatedButton(
                    child: Text('Organiser:' + organiser,
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () {},
                  )),
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
                              return SizedBox(
                                height:
                                MediaQuery.of(context).size.height / 1.3,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          })),
              if (!isInGroup)
                if (_itinerary.date?.day == DateTime.now().day)
                  Container(
                      height: 30,
                      padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                      child: ElevatedButton(
                        child: const Text('Share journey',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          createGroup();
                        },
                      )),
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Planned stops:",
                        style:
                        TextStyle(color: Color(0xFF99D2A9), fontSize: 25)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: _generateStops(),
                ),
              ),
              const SizedBox(height: 20),
              if (isInGroup)
                ElevatedButton(
                  child: const Text('LEAVE GROUP'),
                  onPressed: () {
                    leaveGroup();
                  },
                ),
              if (_itinerary.date?.day == DateTime.now().day ||
                  _itinerary.date?.day == null)
                Container(
                    padding: const EdgeInsets.fromLTRB(70, 5, 70, 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10.0, shape: const StadiumBorder()),
                      child: const Text('START JOURNEY',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapRoutePage(_itinerary)),
                        );
                      },
                    )),
            ],
          ),
        ));
  }

  /// generate the distances and durations between the paths, generate station cards
  List<Widget> _generateStops() {
    List<Widget> smth = [];

    for (int i = 0; i < _itinerary.docks!.length; i++) {
      smth.add(StationTempWidget(
        content: _itinerary.docks![i].name,
        // time: paths[i].duration,
        //TODO: Marija -> you can add the distance and duration here or in a seperate widget, whichever is easier for u :)
        time: 0.0,
      ));
    }
    return smth;
  }

//TODO: Marija display duration and distance -> paths[i].distance, paths[i].duration, do them as you prefer, thats really important
//also i have a commented out future builder, for me it did not work, hopefully it does for u
  _generateStopsFuture() async {
    _itineraryManager = await new ItineraryManager(_itinerary);
    paths = _itineraryManager.getPaths();
  }
}

class StationTempWidget extends StatelessWidget {
  const StationTempWidget(
      {this.first = false,
        this.last = false,
        required this.content,
        required this.time});

  final bool first;
  final bool last;
  final String content;
  final double time;

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
      endChild: Card(
        elevation: 1,
        margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF99D2A9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${time}',
              )
            ],
          ),
        ),
      ),
    );
  }
}
