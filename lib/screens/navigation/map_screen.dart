import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/route_manager.dart';
import '../../helpers/navigation_helpers/navigation_helpers.dart';
import '../../helpers/navigation_helpers/map_drawings.dart';

import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import '../../.env.dart';
import 'package:veloplan/providers/location_service.dart';
import 'turn_by_turn_screen.dart';
import '../../helpers/navigation_helpers/zoom_helper.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_models/main.dart';
import 'package:veloplan/.env.dart';
import 'base_map.dart';

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
  late BaseMapboxMap _map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<NavigationModel>(
        builder: (BuildContext context, Widget? child, NavigationModel model) {
      _map = BaseMapboxMap(false, currentLatLng, model);
      addPositionZoom();
      return SafeArea(child: Stack(children: _map.getWidgets()));
    }));
  }

  void addPositionZoom() {
    _map.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _map.controller?.animateCamera(
              CameraUpdate.newCameraPosition(_map.cameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    ));
  }
}

// TODO: Add walking route  (DONE: Create walking route manager)
// TODO: Duration and distance