import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:veloplan/navbar.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/screens/navigation/turn_by_turn_screen.dart';
import 'package:veloplan/widgets/popup_widget.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../navbar.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapUpdatedRoutePage extends StatefulWidget {
  // const MapPage({Key? key}) : super(key: key);
  // final List<LatLng> _journey;
  final List<DockingStation> _journey;
  final List<LatLng> _points;
  //   LatLng(51.514951, -0.112762),
  //   LatLng(51.513146, -0.115256),
  // LatLng(51.511407, -0.125497),
  // LatLng(51.506053, -0.130310),
  // LatLng(51.502254, -0.217760),
  // ];
  MapUpdatedRoutePage(this._journey, this._points);
  // MapUpdatedRoutePage(this._journey);
  @override
  //original -> change to latlongs
  // _MapUpdatedRoutePageState createState() => _MapUpdatedRoutePageState(points);
  _MapUpdatedRoutePageState createState() =>
      _MapUpdatedRoutePageState(_journey, _points);
}

class _MapUpdatedRoutePageState extends State<MapUpdatedRoutePage> {
  // LatLng currentLatLng = getLatLngFromSharedPrefs();
  late MapWithRouteUpdated _baseMapWithUpdatedRoute;
  final List<LatLng> _journey;
  final List<DockingStation> _docks;
  Timer? timer;
  // late BuildContext _context;
  bool finished = false;

  // _MapUpdatedRoutePageState(this._journey) {
  _MapUpdatedRoutePageState(this._docks, this._journey) {
    // print("points: " + _journey.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      //jounrey to list<docks>
      _baseMapWithUpdatedRoute =
          MapWithRouteUpdated(_journey, _docks, model, context);
      addPositionZoom();
      addStopTurnByTurn();
      return SafeArea(
          child: Stack(children: _baseMapWithUpdatedRoute.getWidgets()));

      ///* listen to isAtGoal if is at goal redirect
    }));
  }

  /// add positional zoom to our widgets
  void addPositionZoom() {
    _baseMapWithUpdatedRoute.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMapWithUpdatedRoute.controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                  _baseMapWithUpdatedRoute.cameraPosition));
          _baseMapWithUpdatedRoute.recenter = true;
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }

  /// add a reroute button to navbar
  void addStopTurnByTurn() {
    _baseMapWithUpdatedRoute.addWidget(Container(
      alignment: Alignment(0.9, -0.90),
      child: FloatingActionButton(
        heroTag: "stop_journey",
        onPressed: () {
          try {
            _baseMapWithUpdatedRoute.isAtGoal = true;
            _baseMapWithUpdatedRoute.reRoute();
          } catch (e) {
            log("failed to push replacement");
          }
        },
        child: const Icon(
          Icons.close_rounded,
        ),
        backgroundColor: Colors.red,
      ),
    ));
  }
}
