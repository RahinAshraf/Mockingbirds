import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const LatLng SOURCE_LOCATION = LatLng(51.51185004458236,
    -0.11580820118980878); //points to bush house - CHANGE this to users current live location
const LatLng DEST_LOCATION = LatLng(42.744421,
    -71.1698939); //dummy value for time being - change DEST_LOCATION to what the user inputs later on
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

const String GOOGLE_API_KEY = "AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU";

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  late LatLng currentLocation;
  late LatLng destinationLocation;

  // Routing
  List<LatLng> destinations = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310)
  ];
  Set<Polyline> polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();

    //set up inital locations
    this.setInitialLocation();
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    late GoogleMapController _googleMapController;

    @override
    void dispose() {
      _googleMapController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
            myLocationEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            polylines: polylines,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller),
        Container(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition)),
              child: const Icon(Icons.center_focus_strong),
            )),
      ]),
    );
  }
}
