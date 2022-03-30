import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import '../../helpers/database_helpers/database_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';

/// Map screen focused on a user's live location
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentPosition = getLatLngFromSharedPrefs();
  late BaseMapboxMap _baseMap;
  DatabaseManager _databaseManager = DatabaseManager();

  @override
  void initState() {
    _deleteOldGroup();
    super.initState();
  }

  Future<void> _deleteOldGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var hasGroup = user.data()!.keys.contains('group');
    if (hasGroup) {
      var group = await _databaseManager.getByEquality(
          'group', 'code', user.data()!['group']);
      group.docs.forEach((element) {
        Timestamp timestamp = element.data()['createdAt'];
        var memberList = element.data()['memberList'];
        if (DateTime.now().difference(timestamp.toDate()) > Duration(days: 1)) {
          element.reference.delete();
          for (String member in memberList) {
            _databaseManager.setByKey(
                'users', member, {'group': null}, SetOptions(merge: true));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMap = BaseMapboxMap(model);
      addPositionZoom();
      addDockingStationCard();
      return SafeArea(child: Stack(children: _baseMap.getWidgets()));
    }));
  }

  void addPositionZoom() async {
    _baseMap.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
          heroTag: "center_to_current_loaction",
          onPressed: () async {
            _baseMap.controller?.animateCamera(CameraUpdate.newCameraPosition(
                await _baseMap.getNewCameraPosition()));
          },
          child: const Icon(Icons.my_location)),
    ));
  }

  void addDockingStationCard() {
    _baseMap.addWidget(Align(
      alignment: Alignment.bottomCenter,
      child: Container(height: 200, child: DockStation(key: dockingStationKey)),
    ));
  }
}
