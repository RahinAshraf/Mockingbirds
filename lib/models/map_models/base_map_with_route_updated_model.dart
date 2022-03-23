// import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapWithRouteUpdated extends BaseMapboxRouteMap {
  late List<LatLng> _journey;
  MapWithRouteUpdated(List<LatLng> journey, MapModel model)
      : super(journey, model) {
    this._journey = journey;
  }
  LatLng _target = getLatLngFromSharedPrefs();
  Timer? timer;
  final Set<Symbol> _polylineSymbols = {};
  bool isAtGoal = false;
  bool firstLoactionCompleted = true;
  late Map<dynamic, dynamic> _routeResponse;
  List<num> distances = [];
  List<num> durations = [];
  List<dynamic> _journeyPoints = [];
  int _currentStation = 0;

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

    // this.controller = controller;
    // model.setController(controller);
    model.fetchDockingStations();
    _displayJourneyAndRefocus();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: _target, zoom: 15, tilt: 5);
    // print("camera position updated!");
  }

  void _updateLiveCameraPosition() {
    if (recenter) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void updateRoute() {
    //! check new if we need to reroute here if yes then we update
    //! check if we are within 10m
    ++_currentStation;
    removePolylineMarkers(controller!, _journey, _polylineSymbols);
    removeFills(controller, _polylineSymbols, fills);
    _displayJourneyAndRefocus();
  }

  void _displayJourneyAndRefocus() {
    setRoute();
    if (isAtGoal) {
      return;
    }
    setPolylineMarkers(controller!, _journey, _polylineSymbols);
  }

  void setRoute() async {
    distances = [];
    durations = [];
    _journeyPoints = [];
    await _setBikeRoute();
    if (isAtGoal) {
      return;
    }
    manager.setDistance(_routeResponse['distance'].toDouble());
    manager.setDuration(_routeResponse['duration'].toDouble());
    manager.setGeometry(_routeResponse['geometry']);

    displayJourney();
  }

  /// sets the next section of the bike route
  Future<void> _setBikeRoute() async {
    if (_currentStation >= _journey.length) {
      return;
    }
    if (firstLoactionCompleted) {
      await _setInitRoute(NavigationType.cycling);
    } else {
      await _setInitRoute(NavigationType.walking);
    }
    // for (int i = _currentStation + 1; i < _journey.length - 1; ++i) {
    //   //CYCLING:
    //   var directions = await manager.getDirections(
    //       _journey[i - 1], _journey[i], NavigationType.cycling);

    //   //update local vars ---
    //   num distance = await manager.getDistance() as num;
    //   num duration = await manager.getDuration() as num;
    //   for (dynamic a in directions['geometry']!['coordinates']) {
    //     _journeyPoints.add(a);
    //   }
    //   distances.add(distance);
    //   durations.add(duration);
    //   _routeResponse['geometry']
    //       .update("coordinates", (value) => _journeyPoints);
    // }
  }

  /// sets the route
  Future<void> _setInitRoute(NavigationType type) async {
    if (_currentStation >= _journey.length) {
      isAtGoal = true;
      return;
    }
    _routeResponse =
        await manager.getDirections(_target, _journey[_currentStation], type);
    //update local vars ---
    num distance = await manager.getDistance() as num;
    num duration = await manager.getDuration() as num;
    for (dynamic a in _routeResponse['geometry']!['coordinates']) {
      _journeyPoints.add(a);
    }
    distances.add(distance);
    durations.add(duration);
    _routeResponse['geometry'].update("coordinates", (value) => _journeyPoints);
  }
}

/// TODO: if user has pressed button refocus on current location if user taps screen go back to follow
/// DONE: split up walking and biking distance, check if you've been on the first goal
/// TODO: check if we're at the last place
/// TODO: if within 10m of target utdate integer
/// TODO: Check endpoints if still avalible -> help Nicole/Lili
/// TODO: Redirect
