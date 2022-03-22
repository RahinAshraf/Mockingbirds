import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';

import '../../widgets/popup_widget.dart';

/// A splash screen displaying turn by turn navigation for a journey.
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,
/// Reference: dormmom.com, Jul 20, 2021, flutter_mapbox_navigation 0.0.26, https://pub.dev/packages/flutter_mapbox_navigation

class TurnByTurn extends StatefulWidget {
  //late List<LatLng> points;
  late var wayPoints = <WayPoint>[];
  TurnByTurn(var points) {
    this.wayPoints = points;
  }

  @override
  State<TurnByTurn> createState() => _TurnByTurnState(this.wayPoints);
}

class _TurnByTurnState extends State<TurnByTurn> {
  //late List<LatLng> points;
  late var wayPoints = <WayPoint>[];

  _TurnByTurnState(var points) {
    // this.points = points;
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
    //if you want to try popup screen which then proceeds to crash
    // return _buildPopupDialog(context, wayPoints);
    return const MapPage();
  }

  /// Turn by turn navigation
  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    log("on route event");

    if (!addThingy) {
      addThingy = false;
      // routeBuilt = false;
      // isNavigating = false;
      wayPoints.add(
          WayPoint(name: "new dest", latitude: 51.4946, longitude: 0.1003));
      print("waypoint length in initialize: " +
          wayPoints.length.toString() +
          "------------------------------------------------------------------");
//terminates the tbt screen
      await directions.finishNavigation();
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
        arrived = true;
        if (arrived) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        }
        break;
      case MapBoxEvent.navigation_finished:
        print(
            "----------------- finishing navigation...... ------------------");
        wayPoints.removeAt(0);
        print("waypoint length in initialize: after removal " +
            wayPoints.length.toString() +
            "------------------------------------------------------------------");
        await Future.delayed(Duration(seconds: 15));
        break;
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }

    /// refresh UI
    setState(() {});
  }

  PopupWidget _buildPopupDialog(BuildContext context, var wayPoints) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        text: "Redirect",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TurnByTurn(wayPoints)));
        },
      ),
      PopupButtonWidget(
        text: "Finish journey",
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapPage()));
        },
      ),
    ];
    return PopupWidget(
        title: "Choose how to proceed with your trip!",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }
}
