import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:http/http.dart';

const double CAMERA_ZOOM = 17;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  GoogleMapController? _googleController;
  Location _currentLocation = Location();

  @override
  void initState() {
    super.initState();
  }

  void showUsersCurrentLocationOnMap() async{
    var location = await _currentLocation.getLocation();
    _currentLocation.onLocationChanged.listen((LocationData loc){
      _googleController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: CAMERA_ZOOM,
      )));
      setState(() {
        // _markers.add(Marker(markerId: MarkerId('Home'),
        //     position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        // ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: LatLng(51.51185004458236,-0.11580820118980878),
    );

    return Scaffold(
        body: ListView(
          children: <Widget> [
            SearchLocation(
            apiKey: 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU',
            country: 'GB',
            language: 'en',
            // onSelected: (Place place) async {
            //   _markers.add(Marker(markerId: MarkerId('Home'),
            //   position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
            //   )); 
            // },  
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:GoogleMap(
              zoomControlsEnabled: true,
              myLocationEnabled :true,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller){
                _googleController = controller;
                showUsersCurrentLocationOnMap();
              },
              markers: _markers,
            ) ,
          ),
          ],

        ),
        
      );
    }
  }

