import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late List<CameraPosition> _LocationsList;
  List<Map> carouselData = [];

  //carousel related:
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    // _initialCameraPosition = CameraPosition(target: latLng, zoom: 15);
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 15);

    _LocationsList = (List<CameraPosition>.generate(
        locations_placeholder.length,
        (index) => CameraPosition(
            //target: getLatLngFromLocationData(carouselData[index]['index']),
            target: getLatLngFromLocationData(index),
            zoom: 15)));
    _LocationsList.add(CameraPosition(target: currentLatLng, zoom: 15));
  }

  //void initializeLocationAndSave() async {
  //Ensure all permissions are collected for Locations
  // Location _location = Location();
  // bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;

  // _serviceEnabled = await _location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await _location.requestService();
  // }

  // _permissionGranted = await _location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await _location.requestPermission();
  // }

  // Capture the current user location
  // LocationData _locationData = await _location.getLocation();
  // LatLng currentLatLng =
  //     LatLng(_locationData.latitude!, _locationData.longitude!);
  // LatLng currentLatLng = LatLng(51.51185004458236, -0.11580820118980878);

  // Store the user location in sharedPreferences

  // sharedPreferences.setDouble('latitude',
  //     (51.51185004458236)); //had ! for null, removed as we provided doubles rather than vars for latlng
  // sharedPreferences.setDouble('longitude', (-0.11580820118980878));
  // sharedPreferences.setDouble('latitude', _locationData.latitude!);
  // sharedPreferences.setDouble('longitude', _locationData.longitude!);

  // Get and store the directions API response in sharedPreferences
  // for (int i = 0; i < locations_placeholder.length; i++) {
  //   Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
  //   //print(currentLatLng.toString());
  //  //saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
  // }

// // Calculate the distance and time from data in SharedPreferences
//       for (int index = 0; index < locations_placeholder.length; index++) {
//         num distance = getDistanceFromSharedPrefs(index) / 1000;
//         num duration = getDurationFromSharedPrefs(index) / 60;
//         carouselData
//             .add({'index': index, 'distance': distance, 'duration': duration});
//       }
//       carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

//       // initialize map symbols in the same order as carousel widgets
  // _LocationsList = (List<CameraPosition>.generate(
  //     locations_placeholder.length,
  //     (index) => CameraPosition(
  //         //target: getLatLngFromLocationData(carouselData[index]['index']),
  //         target: getLatLngFromLocationData(1),
  //         zoom: 15)));

//       for (int i = 0; i < _LocationsList.length; i++) {
//         print(_LocationsList[i]);
//       }

  //}

  //ROUTE:    //from restaurantsmap:
  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    // print(index);
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_LocationsList[currentDestination]));

    // Add a polyLine between source and destination
    Map routeResponse =
        await getDirectionsAPIResponse(currentLatLng, currentDestination);

    //print(modifiedResponse);
    Map geometry = routeResponse['geometry'];

    final _fills = {
      //holds the geometries for the polylines -> used to render
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
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
        lineWidth: 6,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    for (CameraPosition _location in _LocationsList) {
      print("here");
      print(_location.target);
      await controller.addSymbol(
        SymbolOptions(
          geometry: _location.target,
          iconSize: 7.8,
          iconImage: "assets/icon/bike.png",
        ),
      );
    }
  }

  _onStyleLoadedCallback() async {
    //ADDS MARKERS----- doesnt work ???
    for (CameraPosition _location in _LocationsList) {
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
              // heroTag: "RouteBtn",
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
                _addSourceAndLineLayer(pageIndex, true);
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
                // controller.animateCamera(
                //     CameraUpdate.newCameraPosition(_initialCameraPosition));
              },
              child: const Icon(Icons.star),
            ),
          ),
        ],
      ),
    );
  }
}
