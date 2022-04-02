import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';

class GroupId extends StatefulWidget {
  const GroupId({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => GroupIdState();
}

/// Renders a popup widget to join an existing journey with a 6-digit number.
///
/// A user is asked to input a 6-digit code, which is stored in [fullPin]
/// variable. If the code is correct, user 'joins' the group and is then
/// redirected to corresponding [SummaryJourneyScreen].
class GroupIdState extends State<GroupId> {
  final DatabaseManager _databaseManager = DatabaseManager();
  late List<LatLng>? points;
  String fullPin = ''; // user's entered pin code
  bool? exists = null;

  @override
  void initState() {
    super.initState();
  }

  /// Adds user to an group, if the given [code] is correct and sets that group [exists].
  _joinGroup(String code) async {
    var group = await _databaseManager.getByEquality('group', 'code', code);
    var list = [];
    String id = "";

    if (group.size == 0) {
      setState(() {
        exists = false;
      });
    } else {
      setState(() {
        exists = true;
      });

      var _itinerary = await _getDataFromGroup(group);

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

      context.push(SummaryJourneyScreen(_itinerary, false));
    }
  }

  Future<Itinerary> _getDataFromGroup(QuerySnapshot<Map<String, dynamic>> group) async {
    List<DockingStation> _docks = [];
    var geoList = [];
    var _myDestinations;
    var _numberOfCyclists;
    for(var element in group.docs ){
      var itinerary = await element.reference.collection('itinerary').get();
      var journeyIDs = itinerary.docs.map((e) => e.id).toList();
      for( var journeyID in journeyIDs){
        var journey = await element.reference
            .collection('itinerary')
            .doc(journeyID)
            .get();
        _numberOfCyclists = journey.data()!['numberOfCyclists'];
        geoList = journey.data()!['points'];
        var stationCollection =
        await journey.reference.collection("dockingStations").get();
        var stationMap = stationCollection.docs;
        _docks = List.filled(stationMap.length, DockingStation("fill","fill",true,false,-1,-1,-1,10,20), growable: false);
        for(var station in stationMap)({
          _docks[station.data()['index']] = (
            DockingStation(
              station.data()['id'],
              station.data()['name'],
              true,
              false,
              -1,
              -1,
              -1,
              station.data()['location'].longitude,
              station.data()['location'].latitude,
            )
          )
        });
        var coordinateCollection = await journey.reference.collection("coordinates").get();
        var coordMap = coordinateCollection.docs;
        geoList = List.filled(coordMap.length, GeoPoint(10,20));
        for (var value in coordMap) {
          geoList[value.data()['index']]= value.data()['coordinate'];
        }
      }
      List<List<double>> tempList = [];
      for (int i = 0; i < geoList.length; i++) {
        tempList.add([geoList[i].latitude, geoList[i].longitude]);

      }

      _myDestinations = convertListDoubleToLatLng(tempList);

    }
    return Itinerary.navigation(_docks, _myDestinations, _numberOfCyclists);
  }

  /// Returns an error message if the entered code is incorrect.
  String? get _errorText {
    if (exists == false) {
      return "The entered code is incorrect.";
    }
    return null;
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'PIN Code',
                    errorText: _errorText,
                  ),
                  onChanged: (pin) {
                    setState(() {
                      exists = null;
                      fullPin = pin;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 0.5,
                  child: ElevatedButton(
                    onPressed: fullPin.length == 6
                        ? () {
                            _joinGroup(fullPin);
                          }
                        : null,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
