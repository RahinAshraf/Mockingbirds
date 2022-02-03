import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';

const LatLng SOURCE_LOCATION = LatLng(51.51185004458236,
    -0.11580820118980878); //points to bush house - CHANGE this to users current live location
const LatLng DEST_LOCATION = LatLng(42.744421,
    -71.1698939); //dummy value for time being - change DEST_LOCATION to what the user inputs later on
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

// void main() {
//   runApp(MapPage());
// }

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
  GoogleMapController? _googleController;
  Location _currentLocation = Location();


  @override
  void initState() {
    super.initState();

    //set up inital locations
    this.setInitialLocation();
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  // void drawRoute(points){
  //   await
  // }

  void getLocation() async{
    var location = await _currentLocation.getLocation();
    _currentLocation.onLocationChanged.listen((LocationData loc){
      _googleController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 17.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:GoogleMap(
          zoomControlsEnabled: true,
          initialCameraPosition:CameraPosition(
            target: LatLng(48.8561, 2.2930),
            zoom: 16.0,
          ),
          onMapCreated: (GoogleMapController controller){
            _googleController = controller;
          },
          markers: _markers,
        ) ,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching,color: Colors.white,),
        onPressed: (){
          getLocation();
        },
      ),
    );
  }
  }

