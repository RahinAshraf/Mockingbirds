import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/scoped_models/main.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/models/docking_station.dart';

import '../../helpers/navigation_helpers/map_drawings.dart';

/// Class to display a mapbox map with widgets other widgets on top
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
class NavigationMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  late final LatLng _target;
  late MapboxMap _map;
  final List<Widget> _widgets = [];
  final NavigationModel _model;
  late CameraPosition _cameraPosition;
  late MapboxMapController? _controller;
  late Symbol? _selectedSymbol;
  late bool useLiveLocation;

  NavigationMap(this.useLiveLocation, this._target, this._model) {
    _cameraPosition = CameraPosition(target: _target, zoom: 12);
    if (useLiveLocation) {
      setMapWithLiveLocation();
    } else {
      setMapWithoutLiveLocation();
    }
    addWidget(_map);
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
  }

  List<Widget> getWidgets() {
    return _widgets;
  }

  void _onMapCreated(MapboxMapController controller) async {
    _controller = controller;
    _model.setController(_controller!);
    _model.fetchDockingStations();
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager.importStations().then(
        (value) => placeDockMarkers(_controller!, _stationManager.stations));
  }

  Future<void> _onSymbolTapped(Symbol symbol) async {
    _selectedSymbol = symbol;
    Future<LatLng> variable = _controller!.getSymbolLatLng(symbol);
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
}
