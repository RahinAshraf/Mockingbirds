import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapWithRouteUpdated extends BaseMapboxRouteMap {
  late List<LatLng> _journey;
  final BuildContext context;
  MapWithRouteUpdated(List<LatLng> journey, MapModel model, this.context)
      : super(journey, model) {
    this._journey = journey;
  }
  LatLng _target = getLatLngFromSharedPrefs();
  Timer? timer;
  final Set<Symbol> _polylineSymbols = {};
  bool isAtGoal = false;
  bool firstLoactionCompleted = true;
  late Map<dynamic, dynamic> _routeResponse;
  num distance = 0;
  num duration = 0;
  List<dynamic> _journeyPoints = [];
  int _currentStation = 0;
  bool buttonPressed = true;

  @override
  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    _target = LatLng(_newLocationData.latitude!, _newLocationData.longitude!);
  }

  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    print("map created");
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => updateCurrentLocation());
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => _updateCameraPosition());

    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => _updateLiveCameraPosition());
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => updateRoute());
    model.fetchDockingStations();
    _displayJourney();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// update cameraposition
  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: _target, zoom: 15, tilt: 5);
    // print("camera position updated!");
  }

  /// update the live camera position
  void _updateLiveCameraPosition() {
    if (recenter) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void reRoute() {
    // Navigator.popUntil(context, ModalRoute.withName('/map'));
    // Navigator.pop(context, ModalRoute.withName('/map'));
    // Navigator.of(context).pushReplacement(
    //     new MaterialPageRoute(builder: (BuildContext context) => MapPage()));
  }

  /// Update route
  void updateRoute() {
    if (isAtGoal) {
      return;
    }
    double distance = calculateDistance(_target, _journey[_currentStation]);
    if (distance < 1) {
      ++_currentStation;
      if (_currentStation >= _journey.length) {
        print("we got to the goal!!!");
        isAtGoal = true;
        return;
      }
    }
    removePolylineMarkers(controller!, _journey, _polylineSymbols);
    removeFills(controller, _polylineSymbols, fills);
    _displayJourney();
  }

  /// display route
  void _displayJourney() {
    setRoute();
    setPolylineMarkers(controller!, _journey, _polylineSymbols);
  }

  /// set the route
  void setRoute() async {
    _journeyPoints = [];
    await _setRouteType();
    manager.setDistance(_routeResponse['distance'].toDouble());
    manager.setDuration(_routeResponse['duration'].toDouble());
    manager.setGeometry(_routeResponse['geometry']);

    displayJourney();
  }

  /// sets the next section of the bike route
  Future<void> _setRouteType() async {
    if (_currentStation >= _journey.length) {
      return;
    }
    if (_currentStation > 0) {
      await _setInitRoute(NavigationType.cycling);
    } else {
      await _setInitRoute(NavigationType.walking);
    }
    manager.setGeometry(_routeResponse['geometry']);
    print("set bike route done");
  }

  /// sets the route
  Future<void> _setInitRoute(NavigationType type) async {
    print("current station num:" + _currentStation.toString());
    _routeResponse =
        await manager.getDirections(_target, _journey[_currentStation], type);
    //update local vars ---
    num distance = await manager.getDistance() as num;
    num duration = await manager.getDuration() as num;
    for (dynamic a in _routeResponse['geometry']!['coordinates']) {
      _journeyPoints.add(a);
    }
    this.distance = distance;
    this.duration = duration;
    _routeResponse['geometry'].update("coordinates", (value) => _journeyPoints);
  }

  /// updates our camera position to not zoom on us
  @override
  void onMapClick(Point<double> point, LatLng coordinates) async {
    recenter = false;
  }
}

/// DONE: if user has pressed button refocus on current location if user taps screen go back to follow
/// DONE: split up walking and biking distance, check if you've been on the first goal
/// DONE: check if we're at the last place
/// DONE: if within 10m of target utdate integer
/// TODO: Check endpoints if still avalible -> help Nicole/Lili
/// TODO: Redirect
