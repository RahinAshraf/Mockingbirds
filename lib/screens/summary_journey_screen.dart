import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/models/itineraryManager.dart';
import 'package:veloplan/models/path.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../models/itinerary.dart';
import 'navigation/map_with_route_screen.dart';
import 'dart:async';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:veloplan/navbar.dart';
import 'package:veloplan/utilities/dart_exts.dart';

class SummaryJourneyScreen extends StatefulWidget {
  // final List<LatLng> points;
  late Itinerary itinerary;
  SummaryJourneyScreen(this.itinerary, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      SummaryJourneyScreenState(this.itinerary);
}

class SummaryJourneyScreenState extends State<SummaryJourneyScreen> {
  final DatabaseManager _databaseManager = DatabaseManager();
  bool isInGroup = false;
  late String groupID = "";
  late String organiser = "";
  late List<List<double?>?> pointsInDoubles;
  late List<LatLng> pointsCoord;
  late Itinerary _itinerary;
  late List<Path> paths;
  late List<Widget> pathTime = [];

  SummaryJourneyScreenState(this._itinerary) {}

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
    print('1');
    var res;
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var hasGroup = user.data()!.keys.contains('group');
    if (hasGroup) {
      var group = await _databaseManager.getByEquality(
          'group', 'code', user.data()!['group']);
      res = await _getGroupOwner(group);
      pointsInDoubles = [];
      group.docs.forEach((element) {
        var geoList = element.data()['points'];
        for (int i = 0; i < geoList.length; i++) {
          pointsInDoubles.add([geoList[i].latitude, geoList[i].longitude]);
        }
      });
    }
    setState(() {
      isInGroup = hasGroup;
      organiser = user.data()!['username'];
      if (isInGroup) {
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

  void _createGroup() async {
    print("GDGGDG");
    var ownerID = _databaseManager.getCurrentUser()?.uid;
    List list = [];
    list.add(ownerID);
    String destination = "";
    math.Random rng = math.Random();
    String code = rng.nextInt(999999).toString();
    var x = await _databaseManager.getByEquality('group', 'code', code);
    while (x.size != 0) {
      code = rng.nextInt(999999).toString();
      x = await _databaseManager.getByEquality('group', 'code', code);
    }
    List<GeoPoint> geoList = [];
    for (int i = 0; i < pointsInDoubles.length; i++) {
      geoList.add(GeoPoint(pointsInDoubles[i]![0]!, pointsInDoubles[i]![1]!));
    }

    try {
      await _databaseManager.addToCollection('group', {
        'code': code,
        'destination': destination,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'points': geoList,
      });
      await _databaseManager.setByKey(
          'users', ownerID!, {'group': code}, SetOptions(merge: true));

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
    } catch (err) {
      //print(err);
    }
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
        appBar: AppBar(
          title: const Text('Summary of Journey'),
          automaticallyImplyLeading: false,
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
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).primaryColor,
                    child: FutureBuilder<String>(
                        future: _getGroup(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              child: Text(
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
                              height: MediaQuery.of(context).size.height / 1.3,
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
                          print("PUSHD");
                          _createGroup();
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
              // MANO
              // FutureBuilder<List<Widget>>(
              //     future: _generateStopsFuture(),
              //     builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
              //       if (snapshot.hasData) {
              //         log(snapshot.data.toString());
              //         //return snapshot.data!.first;
              //         return pathTime[0];
              //       } else {
              //         return CircularProgressIndicator();
              //       }
              //     }),
              Column(
                children: _generateStops(),
              ),
              //TODO: uncomment if you want the final stop
              // Container(
              //     alignment: Alignment.bottomLeft,
              //     padding: const EdgeInsets.all(10),
              //     child: const Text(
              //       'Final stop:',
              //       style: TextStyle(color: Color(0xFF99D2A9), fontSize: 18),
              //     )),
              const SizedBox(height: 20),
              if (isInGroup)
                Container(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text('LEAVE GROUP',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        _leaveGroup();
                      },
                    )),
              if (_itinerary.date?.day == DateTime.now().day)
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

  List<Widget> _generateStops() {
    List<Widget> smth = [];
    ItineraryManager _itineraryManager = new ItineraryManager(_itinerary);
    paths = _itineraryManager.getPaths();
    for (int i = 0; i < _itinerary.docks!.length; i++) {
      if (i == 0) {
        smth.add(StationTempWidget(
          content: _itinerary.docks![i].name,
          time: 0,
        ));
      } else {
        smth.add(StationTempWidget(
          content: _itinerary.docks![i].name,
          time: 0,
        ));
      }
    }
    return smth;
  }

  Future<List<Widget>> _generateStopsFuture() async {
    for (var path in paths) {
      pathTime.add(StationTempWidget(
        content: "",
        time: path.duration,
      ));
    }
    return pathTime;
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
              ImageIcon(
                AssetImage("assets/images/logo.png"),
                color: Color(0xFF99D2A9),
                size: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
