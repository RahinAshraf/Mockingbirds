import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

import '../../screens/journey_planner_screen.dart';

/// Class to display a mapbox map with other possible widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class BaseMapboxMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  LatLng _target = getLatLngFromSharedPrefs();
  late MapboxMap map;
  final List<Widget> _widgets = [];
  final MapModel model;
  late CameraPosition cameraPosition;
  late MapboxMapController? controller;
  late Symbol? selectedSymbol;
  // late final bool _useLiveLocation;
  Timer? timer;

  late final StreamController<MapPlace>? address;
  final locService = LocationService();

  BaseMapboxMap(this.model, {this.address}) {
    cameraPosition = CameraPosition(target: _target, zoom: 15);
    // if (_useLiveLocation) {
    //   _setMapWithLiveLocation();
    // } else {
    //   _setMapWithoutLiveLocation();
    // }
    _setMapWithLiveLocation();
    addWidget(map);
  }

  /// Adds a [widget] to [_widgets]
  void addWidget(Widget widget) {
    _widgets.add(widget);
  }

  /// Gets all [_widgets]
  List<Widget> getWidgets() {
    return _widgets;
  }

  // @override
  // void onMapCreated(MapboxMapController controller) async {
  //   this.controller = controller;
  //   model.setController(controller);
  // }

  /// Initialize map features
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => updateCurrentLocation());
    if (address == null) {
      model.fetchDockingStations();
      model.controller?.onSymbolTapped.add(onSymbolTapped);
    }
  }

  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    //sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    // print("UPDATED");
    // print(_newLocationData.latitude!);
    // print(_newLocationData.longitude!);
  }

  /// Adds click functionality to map
  void onMapClick(Point<double> point, LatLng coordinates) async {
    if (address != null) {
      Map s = await locService.reverseGeoCode(
          coordinates.latitude, coordinates.longitude);
      address!.sink.add(MapPlace(s['place'], s['location']));
      print(s['place']);
      print("Latitdue");
      print(s['location'].latitude);
      print(coordinates);
    }
  }
  //print(coordinates);

  /// Defines [onSymbolTapped] functionality for a docking station marker
  // void onMarkerTapped(MapboxMapController controller) {
  //   controller.onSymbolTapped.add(onSymbolTapped);
  // }

  /// Retrieves the [stationData] of the docking station [symbol] that was tapped
  Future<void> onSymbolTapped(Symbol symbol) async {
    selectedSymbol = symbol;
    if (selectedSymbol != null) {
      Map<dynamic, dynamic>? stationData = symbol.data;
      print("ON SYMBOL TAPPED");

      displayDockCard(stationData);
    }
  }

  /// Displays card with [stationData] about pressed on docking station
  void displayDockCard(Map<dynamic, dynamic>? stationData) {
    DockingStation station = stationData!["station"];
    DockingStationCard.station(station);
  }

  /// Initialises map with live location
  void _setMapWithLiveLocation() {
    map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
      onMapClick: onMapClick,
    );
  }

  MapboxMap getMap() {
    return map;
  }

  /// Refocus map on specified location [position]
  void resetCameraPosition(LatLng position, double zoom) {
    cameraPosition = CameraPosition(
        target: position, //target, //center,
        zoom: zoom,
        tilt: cameraPosition.zoom);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
