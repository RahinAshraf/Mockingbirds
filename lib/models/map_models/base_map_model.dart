import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/.env.dart';

/// Class to display a mapbox map with other possible widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class BaseMapboxMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  late final LatLng _target;
  late MapboxMap _map;
  final List<Widget> _widgets = [];
  final MapModel model;
  late CameraPosition cameraPosition;
  late MapboxMapController? controller;
  late Symbol? _selectedSymbol;
  late final bool _useLiveLocation;

  BaseMapboxMap(this._useLiveLocation, this._target, this.model) {
    cameraPosition = CameraPosition(target: _target, zoom: 15);
    if (_useLiveLocation) {
      _setMapWithLiveLocation();
    } else {
      _setMapWithoutLiveLocation();
    }
    addWidget(_map);
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
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Adds click functionality to map
  void onMapClick(Point<double> point, LatLng coordinates) async {
    //print(coordinates);
  }

  /// Shows the on tapped docking station information
  Future<void> onSymbolTapped(Symbol symbol) async {
    _selectedSymbol = symbol;
    if (_selectedSymbol != null) {
      Map<dynamic, dynamic>? stationData = symbol.data;
      displayDockCard(stationData);
    }
  }

  /// Shows the information about the pressed docking station
  void displayDockCard(Map<dynamic, dynamic>? stationData) {
    //CHANGE THIS TO CREATE CARD
    //! CAN BE MOVED TO HELPER ONCE HRISTINA IS FINISHED WITH IT
    print("Will call widget next");
    print(stationData);
    //     dockingStationKey.currentState?.setState(() {
    //   dockingStationKey.currentState?.setVisible(true);
    // });
  }

  /// Initialises map without live location
  void _setMapWithoutLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      annotationOrder: [AnnotationType.symbol],
      onMapClick: onMapClick,
    );
  }

  /// Initialises map with live location
  void _setMapWithLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
      onMapClick: onMapClick,
    );
  }
}
