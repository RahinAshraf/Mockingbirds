// import 'dart:async';
// import 'dart:math';
// // import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
// import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';
// // import 'package:latlong/latlong.dart' as ll;
// import 'package:veloplan/screens/location_service.dart';

import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../.env.dart';

// // ! remove
// const LatLng SOURCE_LOCATION = LatLng(51.51185004458236,
//     -0.11580820118980878); //points to bush house - CHANGE this to users current live location
// const LatLng DEST_LOCATION = LatLng(42.744421,
//     -71.1698939); //dummy value for time being - change DEST_LOCATION to what the user inputs later on
// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
// //!

// // const String googleMapsApi = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';

// // const double cameraZoom = 17;
// // const double cameraTilt = 80;
// // const double cameraBearing = 30;

// // class MapPage extends StatefulWidget {
// //   const MapPage({Key? key}) : super(key: key);

// //   @override
// //   State<StatefulWidget> createState() {
// //     return _MyHomePageState();
// //   }
// // }

// class _MyHomePageState extends State<MapPage> {
//   final String key = "AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU";
//   Set<Marker> _markers = Set<Marker>();
//   GoogleMapController? _googleController;
//   Location _currentLocation = Location();

//   // ! remove
//   static final CameraPosition _initialCameraPosition = CameraPosition(
//       zoom: CAMERA_ZOOM,
//       tilt: CAMERA_TILT,
//       bearing: CAMERA_BEARING,
//       target: SOURCE_LOCATION);
// //!
//   // Routing
//   List<LatLng> points = [
//     const LatLng(51.514951, -0.112762),
//     const LatLng(51.513146, -0.115256),
//     const LatLng(51.511407, -0.125497),
//     const LatLng(51.506053, -0.130310)
//   ];
//   MapsRoutes route = new MapsRoutes();
//   DistanceCalculator distanceCalculator = new DistanceCalculator();
//   String totalDistance = 'No route';

//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();

//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   void showUsersCurrentLocationOnMap() async {
//     var location = await _currentLocation.getLocation();
//     _currentLocation.onLocationChanged.listen((LocationData loc) {
//       _googleController
//           ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
//         target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
//         zoom: cameraZoom,
//       )));
//       setState(() {
//         _markers.add(Marker(
//             markerId: MarkerId('Home'),
//             position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     CameraPosition _initialCameraPosition = CameraPosition(
//       zoom: cameraZoom,
//       tilt: cameraTilt,
//       bearing: cameraBearing,
//       target: LatLng(51.51185004458236, -0.11580820118980878),
//     );

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: GoogleMap(
//               myLocationEnabled: false,
//               compassEnabled: false,
//               tiltGesturesEnabled: false,
//               zoomControlsEnabled: true,
//               polylines: Set<Polyline>.of(polylines.values),
//               markers: _markers,
//               mapType: MapType.normal,
//               initialCameraPosition: _initialCameraPosition,
//               onMapCreated: (GoogleMapController controller) {
//                 _googleController = controller;
//               },
//             ),
//           ),
//           Container(
//             alignment: Alignment(-0.9, 0),
//             child: FloatingActionButton(
//               heroTag: "btn1",
//               child: Icon(Icons.arrow_upward, color: Colors.white),
//               onPressed: () async {
//                 if (polylineCoordinates.isNotEmpty) {
//                   clearDirections();
//                 }
//                 _getPolyline(points);
//               },
//             ),
//           ),
//           Container(
//               alignment: Alignment(-0.9, -0.5),
//               child: FloatingActionButton(
//                   heroTag: "btn2",
//                   child: Icon(Icons.location_searching, color: Colors.white),
//                   backgroundColor: Colors.green,
//                   onPressed: showUsersCurrentLocationOnMap)),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   width: 200,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0)),
//                   child: Align(
//                     alignment: Alignment.center,
//                     child:
//                         Text(totalDistance, style: TextStyle(fontSize: 25.0)),
//                   )),
//             ),
//           ),
//           Container(
//               alignment: Alignment(0, -0.9),
//               child: TextFormField(
//                 controller: _searchController,
//                 textCapitalization: TextCapitalization.words,
//                 decoration:
//                     const InputDecoration(hintText: "Search for a location"),
//                 onChanged: (value) {
//                   LocationService().findPlace(value);
//                 },
//               )),
//           Container(
//             alignment: Alignment(0.8, -0.95),
//             child: IconButton(
//                 iconSize: 40,
//                 color: Colors.red, //red for developement - change this!
//                 onPressed: () {
//                   LocationService().getPlace(_searchController.text);
//                 },
//                 icon: const Icon(Icons.search)),
//           ),
//           Container(
//               alignment: Alignment(-0.9, 0.3),
//               child: FloatingActionButton(
//                 heroTag: "btn3",
//                 onPressed: (() {
//                   print(
//                       "When the user presses this btn, a new search box should show - to be implemented!");
//                 }),
//               ))
//         ],
//       ),
//     );
//   }

//   _addPolyLine() {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: Colors.red,
//         points: polylineCoordinates,
//         width: 5);
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   _getPolyline(List<LatLng> _journey) async {
//     List<PolylineResult> journey = await getJurneyResult(_journey);
//     if (journey.isNotEmpty) {
//       journey.forEach((subJurney) {
//         List<PointLatLng> points = subJurney.points;
//         if (points.isNotEmpty) {
//           points.forEach((PointLatLng point) {
//             polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//           });
//         }
//       });
//     }

//     setDistance();
//     _addPolyLine();
//   }

//   Future<List<PolylineResult>> getJurneyResult(List<LatLng> journey) async {
//     List<PolylineResult> results = [];
//     if (journey.length > 1) {
//       for (int i = 0; i < journey.length - 1; ++i) {
//         results.add(await polylinePoints.getRouteBetweenCoordinates(
//           googleMapsApi,
//           PointLatLng(journey[i].latitude, journey[i].longitude),
//           PointLatLng(journey[i + 1].latitude, journey[i + 1].longitude),
//           travelMode: TravelMode.bicycling,
//         ));
//       }
//     }
//     return results;
//   }

//   void clearDirections() {
//     polylines = {};
//     polylineCoordinates = [];
//     polylinePoints = PolylinePoints();
//   }

//   void setDistance() {
//     setState(() {
//       totalDistance = distanceCalculator
//           .calculateRouteDistance(polylineCoordinates, decimals: 1);
//     });
//   }

//   // Returns the distance in KM
//   double calculateDistance(LatLng pos1, LatLng pos2) {
//     var p = 0.017453292519943295;
//     var a = 0.5 -
//         cos((pos2.latitude - pos1.latitude) * p) / 2 +
//         cos(pos1.latitude * p) *
//             cos(pos2.latitude * p) *
//             (1 - cos((pos2.longitude - pos1.longitude) * p)) /
//             2;
//     return 12742 * asin(sqrt(a));
//   }

//   List<LatLng> sortByDist(LatLng start, List<LatLng> points) {
//     points.sort((a, b) => calculateDistance(start, a)
//         .compareTo(calculateDistance(start, b).toDouble()));
//     return points;
//   }
// }

class MapScreen extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapScreen> {
  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(51.5, -0.09),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mockingbirds/ckzh4k81i000n16lcev9vknm5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNremd3NW9weDM2ZmEybm45dzlhYzN0ZnUifQ.lSzpNOhK2CH9-PODR0ojLg",
            additionalOptions: {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox.mapbox-streets-v8'
            },
            attributionBuilder: (_) {
              return Text("VeloPlan");
            },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: latLng.LatLng(51.5, -0.09),
                builder: (ctx) => Container(
                  child: FlutterLogo(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
