import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/navigation_helpers/zoom_helper.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/main.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/screens/navigation/base_map.dart';

import '../../helpers/navigation_helpers/map_drawings.dart';

/// Class to display a mapbox map with a route and other possible widgets
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

class BaseMapboxRouteMap extends BaseMapboxMap {
  late List<LatLng> _journey;
  Map<String, Object> _fills = {};
  Set<Symbol> _polylineSymbols = {};
  String totalDistance = 'No route';
  RouteManager _manager = RouteManager();
  late Map routeResponse;

  BaseMapboxRouteMap(
      this._journey, bool useLiveLocation, LatLng target, NavigationModel model)
      : super(useLiveLocation, target, model) {}

  void displayJourneyAndRefocus(List<LatLng> journey) {
    setJourney(journey);
    refocusCamera(journey);
    setPolylineMarkers(controller!, journey, _polylineSymbols);
  }

  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    displayJourneyAndRefocus(_journey);
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  void refocusCamera(List<LatLng> journey) {
    LatLng center = getCenter(journey);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(journey);
    print("radius: " + calculateDistance(center, corners.item1).toString());
    double zoom = getZoom(calculateDistance(center, corners.item1));

    cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void setJourney(List<LatLng> journey) async {
    List<dynamic> journeyPoints = [];
    if (journey.length > 1) {
      routeResponse = await _manager.getDirections(journey[0], journey[1]);
      for (int i = 0; i < journey.length - 1; ++i) {
        var directions =
            await _manager.getDirections(journey[i], journey[i + 1]);
        for (dynamic a in directions['geometry']['coordinates']) {
          journeyPoints.add(a);
        }
        routeResponse['geometry']
            .update("coordinates", (value) => journeyPoints);
      }
      _fills = await setFills(_fills, routeResponse['geometry']);
      addFills(controller!, _fills, model);
      setDistanceAndTime();
    }
  }

  void setDistanceAndTime() async {
    try {
      var duration = await _manager.getDistance() as double; //meters
      var distance = await _manager.getDuration() as double; //sec
      totalDistance = "distance: " +
          (distance / 1000).truncate().toString() +
          ", duration: " +
          (duration / 60).truncate().toString();
    } catch (e) {
      totalDistance = "Route not avalible";
    }
  }

  String getTotalDistance() {
    return totalDistance;
  }
}
