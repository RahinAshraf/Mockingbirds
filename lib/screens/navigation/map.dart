import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/scoped_models/main.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/models/docking_station.dart';

/// Class to display a mapbox map with widgets on top
/// Author(s): Elisabeth Halvorsen k20077737
class NavigationMap {
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  late final LatLng _target;
  late MapboxMap _map;
  late List<Widget> _widgets;
  late final NavigationModel _model;
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

  void _onMapCreated(MapboxMapController controller) async {
    _controller = controller;
    _model.getStattionManager();
    controller.onSymbolTapped.add(_onSymbolTapped);
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

  void placeDockMarkers(List<DockingStation> docks) {
    for (var station in docks) {
      _controller!.addSymbol(
        SymbolOptions(
            geometry: LatLng(station.lat, station.lon),
            iconSize: 0.7,
            iconImage: "assets/icon/bicycle.png"),
      );
    }
  }
}


//  void updateMap(MapboxMap map) {
//     _model.setMap(map);
//   }

//   void updateCameraPosition(CameraPosition cameraposition) {
//     _model.setCameraPosition(cameraposition);
//   }

//   void updateController(MapboxMapController controller) {
//     _model.setController(controller);
//   }
