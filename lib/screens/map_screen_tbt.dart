import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:convert';
import 'package:location/location.dart';
import '../main.dart';
import '../constants/locations_placeholder.dart';
import '../helpers/location_helper.dart';
import '../helpers/directions_handler.dart';
import '../screens/profile_screen.dart';

import '../screens/nav_screen_tbt.dart';

class MapPageTBT extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPageTBT> {
  @override
  //Mapbox related:
  //LatLng latLng = getLatLngFromSharedPrefs();
  LatLng currentLatLng = LatLng(51.51185004458236, -0.11580820118980878);
  int currentDestination = 2; //tower bridge
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  //mapBoxNavigationViewController; //-- NEED NAVIGATION SDK
  // late MapView mapView;
  late List<CameraPosition> _LocationsList;
  List<Map> carouselData = [];
  late Map _geometry;

  //carousel related:
  // int pageIndex = 0;
  // bool accessed = false;
  // late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 15);

    _LocationsList = (List<CameraPosition>.generate(
        locations_placeholder.length,
        (index) => CameraPosition(
            //target: getLatLngFromLocationData(carouselData[index]['index']),
            target: getLatLngFromLocationData(index),
            zoom: 15)));
    _LocationsList.add(CameraPosition(target: currentLatLng, zoom: 15));
  }

  //ROUTE:    //from restaurantsmap:
  _addSourceAndLineLayer(bool removeLayer) async {
    // Can animate camera to focus on the item
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_LocationsList[currentDestination]));

    // Add a polyLine between source and destination
    Map routeResponse =
        await getDirectionsAPIResponse(currentLatLng, currentDestination);

    _geometry = routeResponse['geometry'];

    final _fills = {
      //holds the geometries for the polylines -> used to render
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          //"properties": <String, dynamic>{},
          "geometry": _geometry,
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
        lineColor: Color.fromARGB(255, 197, 23, 23).toHexStringRGB(),
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
    //ADDS MARKERS----- doesn't work
    for (CameraPosition _location in _LocationsList) {
      await controller.addSymbol(
        SymbolOptions(
          geometry: _location.target,
          iconSize: 7.8,
          iconColor: "rgb(255, 255, 0)",
          iconImage: "assets/icon/bike.png",
        ),
      );
    }
    _addSourceAndLineLayer(false);
  }

//USING MAPBOXMAP----
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
            ),
          ),
          Align(
            alignment: Alignment(-0.7, -0.6),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  //pageIndex = 2;
                });
                _addSourceAndLineLayer(true);
              },
              child: const Text('show!'),
            ),
          ),
          Align(
            alignment: Alignment(-0.7, -0.9),
            child: FloatingActionButton(
              heroTag: "liveLocationBtn",
              onPressed: () {
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition));
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Align(
            alignment: Alignment(0.7, -0.9),
            child: FloatingActionButton(
              heroTag: "startTBTBtn",
              onPressed: () {
                //controller.startNavigation();  //NEED NAVIGATION SDK
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavPageTBT(
                              locationsList: _LocationsList,
                              initialCameraPosition: _initialCameraPosition,
                              geometry: _geometry,
                            )));
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_initialCameraPosition));
              },
              child: const Icon(Icons.star),
            ),
          ),
        ],
      ),
    );
  }
}
