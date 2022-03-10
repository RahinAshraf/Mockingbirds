import 'package:scoped_model/scoped_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/.env.dart';

import '../models/docking_station.dart';
import '../providers/docking_station_manager.dart';
import 'package:flutter/material.dart';

class NavigationModel extends Model {
  String accessToken = MAPBOX_ACCESS_TOKEN;

  // 'pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNrempyNnZtajNkbmkybm8xb3lybWE3MTIifQ.AsZJbQPNRb2N3unNdA98nQ';

  late MapboxMapController? controller;
  late CameraPosition cameraPosition;
  late MapboxMap map;
  LatLng currentLatLng =
      const LatLng(51, -0); //LatLng(51.51185004458236, -0.11580820118980878);
  NavigationModel() {
    cameraPosition = CameraPosition(target: currentLatLng, zoom: 12);
    createMap();
  }

  void _onMapCreated(MapboxMapController controller) async {
    setController(controller);
    fetchDockingStations();
    // controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
  }

  void createMap() {
    map = MapboxMap(
      accessToken: accessToken,
      initialCameraPosition: cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      annotationOrder: [AnnotationType.symbol],
    );
  }

  void placeDockMarkers(List<DockingStation> docks) {
    for (var station in docks) {
      controller!.addSymbol(
        SymbolOptions(
            geometry: LatLng(station.lat, station.lon),
            iconSize: 0.7,
            iconImage: "assets/icon/bicycle.png"),
      );
    }
  }

  MapboxMapController? getController() {
    return controller;
  }

  void setController(MapboxMapController controller) {
    this.controller = controller;
  }

  MapboxMap getMap() {
    return map;
  }

  void setMap(MapboxMap map) {
    this.map = map;
  }

  CameraPosition getCameraPosition() {
    return cameraPosition;
  }

  void setCameraPosition(CameraPosition cameraPosition) {
    this.cameraPosition = cameraPosition;
  }
}
