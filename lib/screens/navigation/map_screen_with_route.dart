import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen showing and focusing on a a selected journey
/// Author(s): Elisabeth Halvorsen k20077737,

class MapPage extends StatefulWidget {
  // const MapPage({Key? key}) : super(key: key);
  final List<List<LatLng>> _journey;
  MapPage(this._journey);
  @override
  _MapPageState createState() => _MapPageState(_journey);
}

class _MapPageState extends State<MapPage> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  late BaseMapboxMap _baseMap;
  late BaseMapboxRouteMap _baseMapWithRoute;
  final List<List<LatLng>> _journey;

  _MapPageState(this._journey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithRoute = BaseMapboxRouteMap(_journey, model);
      addPositionZoom();
      return SafeArea(child: Stack(children: _baseMapWithRoute.getWidgets()));
    }));
  }

  /// add positional zoom to our widgets
  void addPositionZoom() {
    _baseMapWithRoute.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMapWithRoute.controller?.animateCamera(
              CameraUpdate.newCameraPosition(_baseMapWithRoute.cameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }
}
