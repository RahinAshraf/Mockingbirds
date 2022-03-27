import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/.env.dart';

import '../../providers/weather_manager.dart';

/// Class to display a mapbox map with other possible widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class BaseMapboxMap {
  final String accessToken = MAPBOX_ACCESS_TOKEN;
  LatLng currentPosition = getLatLngFromSharedPrefs();
  late MapboxMap map;
  final List<Widget> _widgets = [];
  final MapModel model;
  late CameraPosition cameraPosition;
  late MapboxMapController? controller;
  late Symbol? _selectedSymbol;
  bool recenter = true;

  BaseMapboxMap(this.model) {
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
    model.fetchDockingStations();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Updates the current location with the new one
  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    currentPosition =
        LatLng(_newLocationData.latitude!, _newLocationData.longitude!);
  }

  /// updates the [cameraposition]
  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: currentPosition, zoom: 15);
  }

  /// gets the new [cameraposition]
  CameraPosition getNewCameraPosition() {
    updateCurrentLocation();
    _updateCameraPosition();
    return cameraPosition;
  }

  /// Adds click functionality to map
  void onMapClick(Point<double> point, LatLng coordinates) async {}

  /// Shows the on tapped docking station information
  Future<void> onSymbolTapped(Symbol symbol) async {
    _selectedSymbol = symbol;
    Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
    if (_selectedSymbol != null) {
      LatLng current = await variable;
      displayDockCard(current);
    }
  }

  /// Shows the information about the pressed docking station
  void displayDockCard(LatLng current) {
    //CHANGE THIS TO CREATE CARD
    //! CAN BE MOVED TO HELPER ONCE HRISTINA IS FINISHED WITH IT
    print("Will call widget next");
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
}
