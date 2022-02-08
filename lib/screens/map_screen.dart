import 'dart:async';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:trotter/trotter.dart';

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
    const LatLng(51.514951, -0.112762),
    const LatLng(51.513146, -0.115256),
    const LatLng(51.511407, -0.125497),
    const LatLng(51.506053, -0.130310)
  ];
  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String totalDistance = 'No route';

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

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
            polylines: Set<Polyline>.of(polylines.values),
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
            heroTag: "btn1",
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () async {
              if (polylineCoordinates.isNotEmpty) {
                clearDirections();
              }
              _getPolyline(points);
            },
          ),
        ),
        Container(
            alignment: Alignment(-0.9, -0.5),
            child: FloatingActionButton(
                heroTag: "btn2",
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

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 5);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(List<LatLng> _jurney) async {
    List<PolylineResult> jurney = await getJurneyResult(_jurney);
    if (jurney.isNotEmpty) {
      jurney.forEach((subJurney) {
        List<PointLatLng> points = subJurney.points;
        if (points.isNotEmpty) {
          points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }
      });
    }

    setDistance();
    _addPolyLine();
  }

  Future<List<PolylineResult>> getJurneyResult(List<LatLng> jurney) async {
    List<PolylineResult> results = [];
    if (jurney.length > 1) {
      for (int i = 0; i < jurney.length - 1; ++i) {
        results.add(await polylinePoints.getRouteBetweenCoordinates(
          GOOGLE_API_KEY,
          PointLatLng(jurney[i].latitude, jurney[i].longitude),
          PointLatLng(jurney[i + 1].latitude, jurney[i + 1].longitude),
          travelMode: TravelMode.bicycling,
        ));
      }
    }
    return results;
  }

  void clearDirections() {
    polylines = {};
    polylineCoordinates = [];
    polylinePoints = PolylinePoints();
  }

  void setDistance() {
    setState(() {
      totalDistance = distanceCalculator
          .calculateRouteDistance(polylineCoordinates, decimals: 1);
    });
  }

  double calculateDistance(List<LatLng> coords) {
    return 0;
  }

  num getDistance(ll.LatLng a, ll.LatLng b) {
    ll.Distance dist = new ll.Distance();
    return dist.as(ll.LengthUnit.Centimeter, a, b);
  }

  List<ll.LatLng> sortByDist(ll.LatLng start, List<ll.LatLng> points) {
    points.sort((a, b) =>
        getDistance(start, a).compareTo(getDistance(start, b).toDouble()));
    return points;
  }

  // void sortByDist(){

  // }
}
//! def distance(a, b):
// !    return math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2)

//! self.coords = sorted(self.coords, key=lambda p: distance(p, current_positoin), reverse=True)


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
