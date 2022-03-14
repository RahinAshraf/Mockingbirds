import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/scoped_models/main.dart';
import 'package:veloplan/.env.dart';

/// Class to display a mapbox map with widgets other widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class BaseMapboxMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  late final LatLng _target;
  late MapboxMap _map;
  final List<Widget> _widgets = [];
  final NavigationModel model;
  late CameraPosition cameraPosition;
  late MapboxMapController? controller;
  late Symbol? _selectedSymbol;
  late final bool _useLiveLocation;

  BaseMapboxMap(this._useLiveLocation, this._target, this.model) {
    cameraPosition = CameraPosition(target: _target, zoom: 12);
    if (_useLiveLocation) {
      setMapWithLiveLocation();
    } else {
      setMapWithoutLiveLocation();
    }
    addWidget(_map);
  }

  /// adds a [widget] to [widgets]
  void addWidget(Widget widget) {
    _widgets.add(widget);
  }

  /// get all [widgets]
  List<Widget> getWidgets() {
    return _widgets;
  }

  /// initialize map features
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// shows the on tapped dockingstation information
  Future<void> onSymbolTapped(Symbol symbol) async {
    _selectedSymbol = symbol;
    Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
    if (_selectedSymbol != null) {
      LatLng current = await variable;
      displayDockCard(current);
    }
  }

  /// shows the information about the pressed dockingstattion
  void displayDockCard(LatLng current) {
    //CHANGE THIS TO CREATE CARD
    //! CAN BE MOVED TO HELPER ONCE HRISTINA IS FINISHED WITH IT
    print("Will call widget next");
  }

  /// initialises map without live location
  void setMapWithoutLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      annotationOrder: [AnnotationType.symbol],
    );
  }

  /// initialises map with live location
  void setMapWithLiveLocation() {
    _map = MapboxMap(
      accessToken: _accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      annotationOrder: const [AnnotationType.symbol],
    );
  }
}
