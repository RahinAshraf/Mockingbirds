import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:veloplan/helpers/database_helpers/statistics_helper.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A splash screen displaying turn by turn navigation for a journey.
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,
/// Contributor(s): Eduard Ragea k20067643
/// Reference: dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation

class TurnByTurn extends StatefulWidget {
  late var wayPoints = <WayPoint>[];
  TurnByTurn(var points) {
    this.wayPoints = points;
  }

  @override
  State<TurnByTurn> createState() => _TurnByTurnState(this.wayPoints);
}

class _TurnByTurnState extends State<TurnByTurn> {
  late var wayPoints = <WayPoint>[];

  _TurnByTurnState(var points) {
    wayPoints = points;
  }

  /// Configuration variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  double? distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = true;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;
  bool addThingy = true;
  double? distance;
  String userID = FirebaseAuth.instance.currentUser!.uid;

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
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3));
    // Navigator.of(context).pop(true);
    return NavBar();
  }

  /// Turn by turn navigation
  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;
    if (distance == null) {
      distance = distanceRemaining;
    } else {
      sharedPreferences.setDouble(
          'distance', distance! - (distanceRemaining ?? 0));
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
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        await updateDistanceOnServer(userID);
        directions.finishNavigation();
        break;
      case MapBoxEvent.navigation_finished:
        wayPoints.removeAt(0);
        await Future.delayed(Duration(seconds: 15));
        break;
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        await updateDistanceOnServer(userID);
        break;
      default:
        break;
    }

    /// refresh UI
    setState(() {});
  }
}
