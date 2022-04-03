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
import '../../screens/journey_planner_screen.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';

/// Class to display a mapbox map with other possible widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
/// Contributor: Hristina-Andreea Sararu k20036771
final GlobalKey<DockStationState> dockingStationKey = GlobalKey();

class BaseMapboxMap {
  final String accessToken = MAPBOX_ACCESS_TOKEN;
  LatLng currentPosition = getLatLngFromSharedPrefs();
  late MapboxMap map;
  final List<Widget> _widgets = [];
  final MapModel model;
  late CameraPosition cameraPosition;
  late MapboxMapController? controller;
  late Symbol? selectedSymbol;
  bool recenter = true;
  late Timer timer;
  // late final bool _useLiveLocation;

  late final StreamController<MapPlace>? address;
  final locService = LocationService();

  BaseMapboxMap(this.model, {this.address}) {
    cameraPosition = CameraPosition(target: currentPosition, zoom: 15);
    setMap();
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

  /// Initialize map features
  void onMapCreated(MapboxMapController controller) async {
    await baseMapCreated(controller);
  }

  Future<void> baseMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    await model.fetchDockingStations();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Updates the current location with the new one
  Future<void> updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    // sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    currentPosition =
        LatLng(_newLocationData.latitude!, _newLocationData.longitude!);
  }

  /// Adds click functionality to map
  void onMapClick(Point<double> point, LatLng coordinates) async {
    if (address != null) {
      Map s = await locService.reverseGeoCode(
          coordinates.latitude, coordinates.longitude);
      address!.sink.add(MapPlace(s['place'], s['location']));
    }
  }

  /// updates the [cameraposition]
  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: currentPosition, zoom: 15);
  }

  /// gets the new [cameraposition]
  Future<CameraPosition> getNewCameraPosition() async {
    await updateCurrentLocation();
    _updateCameraPosition();
    return cameraPosition;
  }

  /// Retrieves the [stationData] of the docking station [symbol] that was tapped
  Future<void> onSymbolTapped(Symbol symbol) async {
    selectedSymbol = symbol;
    if (selectedSymbol != null) {
      Map<dynamic, dynamic>? stationData = symbol.data;
      displayDockCard(stationData);
    }
  }

  /// Shows the information about the pressed docking station
  void displayDockCard(Map<dynamic, dynamic>? stationData) {
    DockingStation station = stationData!["station"];
    dockingStationKey.currentState?.setState(() {
      dockingStationKey.currentState?.setData(station, true);
    });
  }

  /// Initialises map with live location
  void setMap() {
    map = MapboxMap(
      accessToken: accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
      onMapClick: onMapClick,
      onMapLongClick: onMapClick,
    );
  }

  /// gets the [map]
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
