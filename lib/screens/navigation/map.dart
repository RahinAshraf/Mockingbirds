import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/scoped_models/main.dart';

class NavigationMap {
  late MapboxMap _map;
  List<Widget> _widgets = [];
  late NavigationModel _model;

  NavigationMap(this._map, this._model) {
    updateMap(_map);
    addWidget(_model.getMap());
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
  }

  List<Widget> getWidgets() {
    return _widgets;
  }

  void updateMap(MapboxMap map) {
    _model.setMap(map);
  }

  void updateCameraPosition(CameraPosition cameraposition) {
    _model.setCameraPosition(cameraposition);
  }

  void updateController(MapboxMapController controller) {
    _model.setController(controller);
  }
}
