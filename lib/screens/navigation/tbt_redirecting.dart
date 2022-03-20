import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversion_helpers.dart';

/// A splash screen displaying turn by turn navigation for a journey.
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,
/// Reference: dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation

class TurnByTurn extends StatefulWidget {
  late List<LatLng> points;
  TurnByTurn(List<LatLng> points) {
    this.points = points;
  }
  @override
  State<TurnByTurn> createState() => _TurnByTurnState(points);
}

class _TurnByTurnState extends State<TurnByTurn> {
  late List<LatLng> points;
  late var wayPoints = <WayPoint>[];

  _TurnByTurnState(List<LatLng> points) {
    this.points = points;
    wayPoints = latLngs2WayPoints(points);
  }

  /// Configuration variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = true;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;
  bool addThingy = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// Initialises the navigation
  Future<void> initialize() async {
    if (!mounted) return;

    /// Setup directions and options
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.cycling,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: true,

        ///false to use live movement
        language: "en");

    /// Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
    // while (!arrived) {
    //   navigationInti();
    // }
  }

  // Future<void> navigationInti() async {
  //   /// Setup directions and options
  //   directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
  //   _options = MapBoxOptions(
  //       zoom: 18.0,
  //       voiceInstructionsEnabled: true,
  //       bannerInstructionsEnabled: true,
  //       mode: MapBoxNavigationMode.cycling,
  //       isOptimized: true,
  //       units: VoiceUnits.metric,
  //       simulateRoute: true,

  //       ///false to use live movement
  //       language: "en");

  //   /// Start the trip
  //   await directions.startNavigation(wayPoints: wayPoints, options: _options);
  // }

  void startNav() async {
    bool routeBuilt = false;
    bool isNavigating = false;
    arrived = false;
    initialize(); //waypoints3
    // directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    // await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    // if (!addThingy) {
    //   print(
    //       "----------------------------- I got to build --------------------");
    //   startNav();
    // }
    return const MapPage();
  }

  /// Turn by turn navigation
  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    log("on route event");

    if (addThingy) {
      addThingy = false;
      // routeBuilt = false;
      // isNavigating = false;
      wayPoints.add(
          WayPoint(name: "new dest", latitude: 51.4946, longitude: 0.1003));
      print("waypoint length in initialize: " +
          wayPoints.length.toString() +
          "------------------------------------------------------------------");

      await directions.finishNavigation();

      await directions.startNavigation(wayPoints: wayPoints, options: _options);
      print(
          "------------------------closing screen.... in the if-------------------");
    }

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        print("----------------- on arrival -----------------");
        arrived = true;
        if (arrived) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        }
        break;
      case MapBoxEvent.navigation_finished:
        print(
            "----------------- finishing navigation...... ------------------");
        break;
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        print("----------------- canceling navigation..... ------------------");
        break;
      default:
        break;
    }

    /// refresh UI
    setState(() {});
  }
}
