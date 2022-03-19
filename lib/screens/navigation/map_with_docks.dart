import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen showing and focusing on specific dock and the filtered docks
/// Author(s): Fariha Choudhury k20059723,

class MapDockPage extends StatefulWidget {
  late List<LatLng> _docks;
  MapDockPage(this._docks);

  @override
  _MapDockPageState createState() => _MapDockPageState(_docks);
}

class _MapDockPageState extends State<MapDockPage> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  late BaseMapboxRouteMap _baseMapWithRoute;
  final List<LatLng> _docks;
  late LatLng _focusDock;
  _MapDockPageState(this._docks);

  /// Sets [_focusDock] to be the dock that the user selected from sliding cards
  void setFocusDock(LatLng dock) {
    this._focusDock = dock;
  }

  /// Sets [_docks] to be the list of docks the user has filtered to display and the chosen dock
  void setDocks(List<LatLng> docks) {
    _docks.clear();
    for (var station in docks) {
      _docks.add(station);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithRoute = BaseMapboxRouteMap(
          _docks, model, false); //FALSE: DONT DISPLAY POLYLINE - ONLY MARKERS
      _baseMapWithRoute.controller?.animateCamera(
          //SET CAMERA POSITION TO FOCUS ON CHOSEN DOCK
          CameraUpdate.newCameraPosition(
              CameraPosition(target: this._focusDock, zoom: 12, tilt: 5)));
      return SafeArea(child: Stack(children: _baseMapWithRoute.getWidgets()));
    }));
  }
}
