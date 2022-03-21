import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:veloplan/screens/navigation/turn_by_turn_screen.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapUpdatedRoutePage extends StatefulWidget {
  // const MapPage({Key? key}) : super(key: key);
  // final List<LatLng> _journey;
  List<LatLng> points = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310),
    LatLng(51.502254, -0.217760),
  ];
  // MapUpdatedRoutePage(this._journey);
  @override
  _MapUpdatedRoutePageState createState() => _MapUpdatedRoutePageState(points);
}

class _MapUpdatedRoutePageState extends State<MapUpdatedRoutePage> {
  // LatLng currentLatLng = getLatLngFromSharedPrefs();
  late MapWithRouteUpdated _baseMapWithUpdatedRoute;
  final List<LatLng> _journey;

  _MapUpdatedRoutePageState(this._journey) {
    print("points: " + _journey.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithUpdatedRoute = MapWithRouteUpdated(_journey, model);
      addPositionZoom();
      return SafeArea(
          child: Stack(children: _baseMapWithUpdatedRoute.getWidgets()));
    }));
  }

  /// add positional zoom to our widgets
  void addPositionZoom() {
    _baseMapWithUpdatedRoute.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMapWithUpdatedRoute.controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                  _baseMapWithUpdatedRoute.cameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }
}
