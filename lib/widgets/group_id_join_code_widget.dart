import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/utilities/dart_exts.dart';

import '../helpers/database_manager.dart';
import '../helpers/navigation_helpers/navigation_conversions_helpers.dart';
import '../models/itinerary.dart';
import '../models/itineraryManager.dart';
import '../screens/summary_journey_screen.dart';

class GroupId extends StatefulWidget {
  const GroupId({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GroupIdState();
}

class GroupIdState extends State<GroupId> {
  String fullPin = '';
  bool? groupExists;
  late List<LatLng>? points;
  final DatabaseManager _databaseManager = DatabaseManager();
  bool? exists = null;

  @override
  void initState() {
    super.initState();
  }

  _joinGroup(String code) async {
    print(" CODDD " + code);
    var group = await _databaseManager.getByEquality('group', 'code', code);

   var list = [];
    var geoList;
    String id = "";

    if (group.size == 0) {
      setState(() {
        exists = false;
      });
    } else {
      print(4);
      setState(() {
        exists = true;
      });

      // TODO: add the names as well for summary of journey!


     var _itinerary =  _getDataFromGroup(group);


      group.docs.forEach((element) async {

      id = element.id;
      list = element.data()['memberList'];
      list.add(_databaseManager.getCurrentUser()?.uid);
      _databaseManager.setByKey(
          'users',
          _databaseManager.getCurrentUser()!.uid,
          {'group': element.data()['code']},
          SetOptions(merge: true));
    });
    await _databaseManager.updateByKey('group', id, {'memberList': list});

     context.push(SummaryJourneyScreen(_itinerary));
  }
}

Itinerary _getDataFromGroup(QuerySnapshot<Map<String, dynamic>> group){
  List<DockingStation> _docks = [];
  var geoList = [];
  var _myDestinations;
  var  _numberOfCyclists;
  group.docs.forEach((element) async {
    var itinerary = await element.reference.collection('itinerary').get();
    var journeyIDs = itinerary.docs.map((e) => e.id ).toList();
    journeyIDs.forEach((journeyID) async {
      var journey = await element.reference.collection('itinerary').doc(journeyID).get();
      _numberOfCyclists = journey.data()!['numberOfCyclists'];
      geoList = journey.data()!['points'];
      var stationCollection = await  journey.reference.collection("dockingStations").get();
      var stationMap = stationCollection.docs.map((e) => e.data());
      stationMap.forEach((station) {
        _docks.add(DockingStation(
            station['id'],
            station['name'],
            true,
            false,
            -1,
            -1,
            -1,
            station['location'].longitude,
          station['location'].latitude,
        ),);
      });

    });
    List<List<double>> tempList = [];
    for (int i = 0; i < geoList.length; i++) {
      tempList.add([geoList[i].latitude, geoList[i].longitude]);
    }
    _myDestinations = convertListDoubleToLatLng(tempList);

  });
      return  Itinerary.navigation(_docks, _myDestinations, _numberOfCyclists);
  }

Widget build(BuildContext context) {
  return AlertDialog(
    contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
    titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
    title: const Center(
      child: Text(
        "Enter PIN",
        textAlign: TextAlign.center,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextField(
                  maxLength: 6,
                  onChanged: (pin) {
                    // TODO: do something with the pin
                    fullPin = pin;
                    print("The pin: " + pin);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      _joinGroup(fullPin);
                    },
                    child: const Text('Confirm'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
