import 'dart:async';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

const LatLng SOURCE_LOCATION = LatLng(51.51185004458236,
    -0.11580820118980878); //points to bush house - CHANGE this to users current live location
const LatLng DEST_LOCATION = LatLng(42.744421,
    -71.1698939); //dummy value for time being - change DEST_LOCATION to what the user inputs later on
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

const String GOOGLE_API_KEY = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';

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

  static final CameraPosition _initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION);

  // Routing
  List<LatLng> points = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310)
  ];
  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String googleApiKey = 'AIzaSyB7YSQkjjqmYU1LAz91lyYAvCpqFRhFdU';
  String totalDistance = 'No route';

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

  void getLocation() async {
    var location = await _currentLocation.getLocation();
    _currentLocation.onLocationChanged.listen((LocationData loc) {
      _googleController
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 17.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            myLocationEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            polylines: route.routes,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Container(
          alignment: Alignment(-0.9, 0),
          child: FloatingActionButton(
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () async {
              await route.drawRoute(points, 'Test routes',
                  Color.fromRGBO(255, 0, 0, 1.0), GOOGLE_API_KEY,
                  travelMode: TravelModes.bicycling);
              setState(() {
                totalDistance = distanceCalculator
                    .calculateRouteDistance(points, decimals: 1);
              });
            },
          ),
        ),
        Container(
            alignment: Alignment(-0.9, -0.5),
            child: FloatingActionButton(
                child: Icon(Icons.location_searching, color: Colors.white),
                backgroundColor: Colors.green,
                onPressed: _goToInitialPosition)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(totalDistance, style: TextStyle(fontSize: 25.0)),
                )),
          ),
        )
      ]),
    );
  }

  Future<void> _goToInitialPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }
}


//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child:GoogleMap(
//           zoomControlsEnabled: true,
//           initialCameraPosition:CameraPosition(
//             target: LatLng(48.8561, 2.2930),
//             zoom: 16.0,
//           ),
//           ,
//           markers: _markers,
//         ) ,
//       ),
//       ,
// >>>>>>> 632786326e0db07f12fc16d520e19ecdf984c71c
//     );
//   }
//   }

//!
// onMapCreated: (GoogleMapController controller){
//             _googleController = controller;
//             getLocation();
//           }

// floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.location_searching,color: Colors.white,),
//         onPressed: (){
//           getLocation();
//         },
//       )
