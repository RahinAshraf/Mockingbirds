import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapUpdatedRoutePage extends StatefulWidget {
  final Itinerary _itinerary;
  MapUpdatedRoutePage(this._itinerary);
  @override
  _MapUpdatedRoutePageState createState() =>
      _MapUpdatedRoutePageState(this._itinerary);
}

class _MapUpdatedRoutePageState extends State<MapUpdatedRoutePage> {
  LatLng currentPosition = getLatLngFromSharedPrefs();
  late MapWithRouteUpdated _baseMapWithUpdatedRoute;
  Timer? timer;
  bool finished = false;
  final Itinerary _itinerary;

  @override
  void initState() {
    super.initState();
  }

  _MapUpdatedRoutePageState(this._itinerary) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithUpdatedRoute = MapWithRouteUpdated(
        model,
        context,
        _itinerary,
      );
      addPositionZoom();
      addStopTurnByTurn(context);
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
          _baseMapWithUpdatedRoute.recenter = true;
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }

  /// add a reroute button to navbar
  void addStopTurnByTurn(BuildContext context) {
    _baseMapWithUpdatedRoute.addWidget(Container(
      alignment: Alignment(-0.9, -0.90),
      child: FloatingActionButton(
        heroTag: "stop_journey",
        onPressed: () {
          try {
            _baseMapWithUpdatedRoute.isAtGoal = true;
            Navigator.of(context).popUntil((route) => route.isFirst);
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
