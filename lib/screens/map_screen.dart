<<<<<<< HEAD
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

const LatLng SOURCE_LOCATION = LatLng(51.51185004458236, -0.11580820118980878); //points to bush house - CHANGE this to users current live location
const LatLng DEST_LOCATION = LatLng(42.744421,-71.1698939); //dummy value for time being - change DEST_LOCATION to what the user inputs later on
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

void main() {
  runApp(MapPage());
}

class MapPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return _MyHomePageState();
  } 
}

class _MyHomePageState extends State<MapPage>{

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  late LatLng currentLocation;
  late LatLng destinationLocation;

  @override
  void initState() {
    super.initState();
    
    //set up inital locations
    this.setInitialLocation();
  }

  void setInitialLocation(){
    currentLocation = LatLng(
      SOURCE_LOCATION.latitude,
      SOURCE_LOCATION.longitude
    );

    destinationLocation = LatLng(
      DEST_LOCATION.latitude,
      DEST_LOCATION.longitude
    );
  }

  @override 
  Widget build(BuildContext context){

    CameraPosition _initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION
    );

      return MaterialApp(
        home: Stack(
          children: <Widget> [
            Positioned.fill(
              child: GoogleMap(
              myLocationEnabled: false,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Padding(
            padding:EdgeInsets.all(56.0),
            child: FloatingActionButton(onPressed: () {
                FirebaseAuth.instance.signOut();
            },)),
        ],
      )
    );
  }
}

=======
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../.env.dart';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  late Future<List<DockingStation>> future_docks;
  Set<Marker> _markers = Set<Marker>();
  @override
  void initState() {
    super.initState();
    fetchDockingStations();
  }



  void fetchDockingStations(){
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager.importStations().then((value) => placeDockMarkers(_stationManager.stations));
  }

  void placeDockMarkers(List<DockingStation> docks){
    int i =0;
    setState(() {
      for (var station in docks) {
        _markers.add(Marker(
            point: LatLng(station.lat, station.lon),
            builder: (_) {
              return Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://www.iconpacks.net/icons/1/free-icon-bicycle-1054.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            })
        );
      }

    });

  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.51185004458236, -0.11580820118980878),
                  zoom: 16.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                    "https://api.mapbox.com/styles/v1/mockingbirds/ckzh4k81i000n16lcev9vknm5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNremd3NW9weDM2ZmEybm45dzlhYzN0ZnUifQ.lSzpNOhK2CH9-PODR0ojLg",
                    additionalOptions: {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': 'mapbox.mapbox-streets-v8',
                    },
                  ),
                  MarkerLayerOptions(
                    markers:_markers.toList()
                    // Marker(
                    //     point: LatLng(
                    //         51.51185004458236, -0.11580820118980878),
                    //     builder: (_) {
                    //       return Container(
                    //         height: 50,
                    //         width: 50,
                    //         decoration: BoxDecoration(
                    //           color: Colors.red[300],
                    //           shape: BoxShape.circle,
                    //         ),
                    //       );
                    //     }),
                    ,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
>>>>>>> main
