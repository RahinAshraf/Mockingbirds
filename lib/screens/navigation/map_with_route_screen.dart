import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/screens/navigation/turn_by_turn_screen.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';

/// Map screen showing and focusing on a a selected journey
/// Author(s): Elisabeth Halvorsen k20077737,

class MapRoutePage extends StatefulWidget {
  // const MapPage({Key? key}) : super(key: key);
  final List<LatLng> _journey;
  final List<DockingStation> _journeyDocks;
  MapRoutePage(this._journey, this._journeyDocks);
  @override
  _MapRoutePageState createState() =>
      _MapRoutePageState(_journey, _journeyDocks);
}

class _MapRoutePageState extends State<MapRoutePage> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  late BaseMapboxMap _baseMap;
  late BaseMapboxRouteMap _baseMapWithRoute;
  final List<LatLng> _journey;
  final List<DockingStation> _journeyDocks;

  _MapRoutePageState(this._journey, this._journeyDocks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithRoute = BaseMapboxRouteMap(_journey, model);
      addPositionZoom();
      startTurnByTurn(context, _journey);

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

  /// adds turn a turn by turn to our list of widgets
  void startTurnByTurn(BuildContext context, List<LatLng> subJourney) {
    _baseMapWithRoute.addWidget(Container(
      alignment: Alignment(0, 0),
      child: FloatingActionButton(
          heroTag: "start_turn_by_trun",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TurnByTurn(subJourney)),
            );
          }),
    ));
  }
}
