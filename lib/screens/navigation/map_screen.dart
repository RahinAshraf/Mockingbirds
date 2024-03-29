import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';

/// Map screen focused on a user's live location.
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
  late groupManager _groupManager;

  _MapPageState() {
    _groupManager = groupManager(_databaseManager);
  }

  @override
  void initState() {
    _groupManager.deleteOldGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
          _baseMap = BaseMapboxMap(model);
          addPositionZoom();
          addDockingStationCard();
          return Stack(children: _baseMap.getWidgets());
        },
      ),
    );
  }

  /// Adds centration button to map to refocus [CameraPosition] to user's live location
  void addPositionZoom() async {
    _baseMap.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 8.0,
          heroTag: "center_to_current_location",
          key: Key("position_Zoom"),
          onPressed: () async {
            _baseMap.controller?.animateCamera(CameraUpdate.newCameraPosition(
                await _baseMap.getNewCameraPosition()));
          },
          child: Icon(Icons.my_location)),
    ));
  }

  /// Adds docking station card widgets to map, to be displayed when bike symbols are tapped
  void addDockingStationCard() {
    _baseMap.addWidget(Align(
      alignment: Alignment.bottomCenter,
      child: Container(height: 200, child: DockStation(key: dockingStationKey)),
    ));
  }
}
