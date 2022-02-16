import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../screens/nav_screen_tbt.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
// import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart' as latLng;
//import '../.env.dart';

// import 'package:latlong2/latlong.dart' ;
import 'package:mapbox_gl/mapbox_gl.dart';
//import 'package:veloplan/screens/profile_screen.dart';
import 'dart:convert';
import 'package:location/location.dart';
import '../main.dart';
import '../constants/locations_placeholder.dart';
import '../helpers/location_helper.dart';
import '../helpers/directions_handler.dart';
import '../screens/profile_screen.dart';
//import '../helpers/shared_prefs.dart';

class NavPageTBT extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final Map geometry;
  final List<CameraPosition> locationsList;

  const NavPageTBT(
      {Key? key,
      required this.initialCameraPosition,
      required this.geometry,
      required this.locationsList})
      : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<NavPageTBT> {
  @override
  LatLng currentLatLng = LatLng(51.51185004458236, -0.11580820118980878);
  int currentDestination = 2; //tower bridge
  // late CameraPosition _initialCameraPosition;

  late MapboxMapController controller;

  //carousel related:
  int pageIndex = 0;
  bool accessed = false;

  @override
  void initState() {
    super.initState();
  }

  //ROUTE:    //from restaurantsmap:
  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(CameraUpdate.newCameraPosition(
        widget.locationsList[currentDestination]));

    // Add a polyLine between source and destination
    // Map routeResponse =
    //     await getDirectionsAPIResponse(currentLatLng, currentDestination);

    // Map geometry = routeResponse['geometry'];

    final _fills = {
      //holds the geometries for the polylines -> used to render
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": widget.geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await controller.removeLayer("lines");
      await controller.removeSource("fills");
    }

    // Add new source and lineLayer
    await controller.addSource(
        "fills", GeojsonSourceProperties(data: _fills)); //creates the line
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Color.fromARGB(255, 42, 26, 187).toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 5,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    //ADDS MARKERS----- doesnt work ???
    for (CameraPosition _location in widget.locationsList) {
      print("here");
      print(_location.target);
      await controller.addSymbol(
        SymbolOptions(
          geometry: _location.target,
          iconSize: 7.8,
          iconColor: "rgb(255, 255, 0)",
          iconImage: "assets/icon/bike.png",
        ),
      );
    }
    _addSourceAndLineLayer(1, false);
  }

//USING MAPBOXMAP---- for nav screen
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: widget.initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
          ),
        ],
      ),
    );
  }
}
