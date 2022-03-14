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

import '../../helpers/navigation_helpers/map_drawings.dart';

/// Class to display a mapbox map with widgets other widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class BaseMapboxMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  late final LatLng _target;
  late MapboxMap _map;
  final List<Widget> _widgets = [];
  final NavigationModel _model;
  late CameraPosition _cameraPosition;
  late MapboxMapController? controller;
  late Symbol? _selectedSymbol;
  late bool _useLiveLocation;

  //! inherited part
  late List<LatLng> _journey;
  Map<String, Object> _fills = {};
  Set<Symbol> _polylineSymbols = {};
  String totalDistance = 'No route';
  RouteManager _manager = RouteManager();
  late Map routeResponse;

  BaseMapboxMap(
      this._useLiveLocation, this._journey, this._target, this._model) {
    _cameraPosition = CameraPosition(target: _target, zoom: 12);
    if (_useLiveLocation) {
      setMapWithLiveLocation();
    } else {
      setMapWithoutLiveLocation();
    }
    addWidget(_map);
    // displayJourneyAndRefocus(_journey);
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
  }

  List<Widget> getWidgets() {
    return _widgets;
  }

  void _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    _model.setController(controller);
    _model.fetchDockingStations();
    displayJourneyAndRefocus(_journey);
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  Future<void> _onSymbolTapped(Symbol symbol) async {
    _selectedSymbol = symbol;
    Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
    if (_selectedSymbol != null) {
      LatLng current = await variable;
      displayDockCard(current);
    }
  }

  void displayDockCard(LatLng current) {
    //CHANGE THIS TO CREATE CARD
    //! CAN BE MOVED TO HELPER ONCE HRISTINA IS FINISHED WITH IT
    print("Will call widget next");
  }

  void setMapWithoutLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: _cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      annotationOrder: [AnnotationType.symbol],
    );
  }

  void setMapWithLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: _cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
    );
  }

  //! ------------------------- extend to another class -----------------------------------

  void displayJourneyAndRefocus(List<LatLng> journey) {
    setJourney(journey);
    refocusCamera(journey);
    setPolylineMarkers(controller!, journey, _polylineSymbols);
  }

  void refocusCamera(List<LatLng> journey) {
    LatLng center = getCenter(journey);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(journey);
    print("radius: " + calculateDistance(center, corners.item1).toString());
    double zoom = getZoom(calculateDistance(center, corners.item1));

    _cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
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
      addFills(controller!, _fills, _model);
      setDistanceAndTime();
    }
  }

  void setDistanceAndTime() async {
    try {
      var duration = await _manager.getDistance() as double; //meters
      var distance = await _manager.getDuration() as double; //sec
      print(duration.truncate());
      totalDistance = "distance: " +
          (distance / 1000).truncate().toString() +
          ", duration: " +
          (duration / 60).truncate().toString();
      print(totalDistance);
    } catch (e) {
      totalDistance = "Route not avalible";
    }
  }
}
