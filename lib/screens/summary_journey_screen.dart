import 'dart:developer';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/models/itineraryManager.dart';
import 'package:veloplan/models/path.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../models/itinerary.dart';
import 'navigation/map_with_route_screen.dart';
import 'dart:async';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/navbar.dart';
import 'package:veloplan/utilities/dart_exts.dart';

/// Class useful to present the chosen docking stations and destinations by the user, distances and durations about their itinerary, a code for people to create a group
///Author(s): Nicole, Marija, Lilliana, Hristina

class SummaryJourneyScreen extends StatefulWidget {
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
  late ItineraryManager _itineraryManager;

  SummaryJourneyScreenState(this._itinerary) {
    _itineraryManager = new ItineraryManager(_itinerary);
    paths = _itineraryManager.getPaths();
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
    var ownerID = _databaseManager.getCurrentUser()?.uid;
    List list = [];
    list.add(ownerID);
    math.Random rng = math.Random();
    String code = rng.nextInt(999999).toString();
    var x = await _databaseManager.getByEquality('group', 'code', code);
    while (x.size != 0) {
      code = rng.nextInt(999999).toString();
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
      await _databaseManager.addToCollection('group', {
        'code': code,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      await _databaseManager.setByKey(
          'users', ownerID!, {'group': code}, SetOptions(merge: true));

      var group = await _databaseManager.getByEquality('group', 'code', code);
      group.docs.forEach((element) async {
        element.reference.collection('itinerary').add({
          'journeyID': _itinerary.journeyDocumentId,
          'points': geoList,
          'date': _itinerary.date,
          'numberOfCyclists': _itinerary.numberOfCyclists
        });
        var journey = await element.reference
            .collection('itinerary')
            .where('journeyID', isEqualTo: _itinerary.journeyDocumentId)
            .get();
        var dockingStationList = _itinerary.docks!;
        for (int i = 0; i < dockingStationList.length; i++) {
          var station = dockingStationList[i];
          journey.docs.forEach((jour) {
            jour.reference.collection("dockingStations").add({
              'id': station.stationId,
              'name': station.name,
              'location': GeoPoint(station.lat, station.lon),
            });
          });
        }
      });

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
        appBar: AppBar(
          title: const Text('Summary of Journey'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
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
                    _leaveGroup();
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
