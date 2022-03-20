import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';

/// Map screen focused on a user's live location
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,

const double zoom = 16; //! REMOVE

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentLatLng = const LatLng(51.51185004458236, -0.11580820118980878);
  late BaseMapboxMap _baseMap;
  late BaseMapboxRouteMap _baseMapWithRoute;

  // /// ! show usage of BaseMapboxRouteMap

  // List<LatLng> points = [
  //   LatLng(51.514951, -0.112762),
  //   LatLng(51.513146, -0.115256),
  //   LatLng(51.511407, -0.125497),
  //   LatLng(51.506053, -0.130310),
  //   LatLng(51.502254, -0.217760),
  // ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(body: ScopedModelDescendant<MapModel>(
  //       builder: (BuildContext context, Widget? child, MapModel model) {
  //     _baseMapWithRoute =
  //         BaseMapboxRouteMap(points, false, currentLatLng, model);
  //     addPositionZoom();
  //     return SafeArea(child: Stack(children: _baseMapWithRoute.getWidgets()));
  //   }));
  // }

  // /// add positional zoom to our widgets
  // void addPositionZoom() {
  //   _baseMapWithRoute.addWidget(Container(
  //     alignment: Alignment(0.9, 0.90),
  //     child: FloatingActionButton(
  //       heroTag: "center_to_current_loaction",
  //       onPressed: () {
  //         _baseMapWithRoute.controller?.animateCamera(
  //             CameraUpdate.newCameraPosition(_baseMapWithRoute.cameraPosition));
  //       },
  //       child: const Icon(Icons.my_location),
  //     ),
  //   ));
  // }

  // /// ! show usage of BaseMapboxMap

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MapModel>(
          builder: (BuildContext context, Widget? child, MapModel model) {
        _baseMap = BaseMapboxMap(false, currentLatLng, model);
        addPositionZoom();
        return SafeArea(
            child: Stack(
                children: _baseMap.getWidgets() +
                    [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 175,
                            child: DockStation(key: dockingStationKey)),
                      )
                    ]));
      }),
    );
  }

  void addPositionZoom() {
    _baseMap.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMap.controller?.animateCamera(
              CameraUpdate.newCameraPosition(_baseMap.cameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }
}
