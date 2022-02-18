import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/route_manager.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../helpers/navigation_helpers.dart';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  late RouteManager manager;
  late Future<List<DockingStation>> future_docks;
  bool isRouteDisplayed = false;
  Map<String, Object> _fills = {};
  Map routeResponse = {};
  // Set<Marker> _markers = Set<Marker>();

  // var zoom = LatLng(51.51185004458236, -0.11580820118980878);
  String googleMapsApi = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';
  String accessToken =
      'pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNrempyNnZtajNkbmkybm8xb3lybWE3MTIifQ.AsZJbQPNRb2N3unNdA98nQ';

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  List<LatLng> points = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310)
  ];

  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;
  LatLng currentLatLng = const LatLng(51.51185004458236, -0.11580820118980878);

  String totalDistance = 'No route';

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: currentLatLng, zoom: 12);
    // fetchDockingStations();
  }

  // void fetchDockingStations() {
  //   final dockingStationManager _stationManager = dockingStationManager();
  //   _stationManager
  //       .importStations()
  //       .then((value) => placeDockMarkers(_stationManager.stations));
  // }

  // void placeDockMarkers(List<DockingStation> docks) {
  //   int i = 0;
  //   setState(() {
  //     for (var station in docks) {
  //       _markers.add(Marker(
  //           point: LatLng(station.lat, station.lon),
  //           builder: (_) {
  //             return Container(
  //               height: 30,
  //               width: 30,
  //               decoration: BoxDecoration(
  //                 color: Colors.red[100],
  //                 shape: BoxShape.circle,
  //                 image: const DecorationImage(
  //                   image: NetworkImage(
  //                       'https://www.iconpacks.net/icons/1/free-icon-bicycle-1054.png'),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             );
  //           }));
  //     }
  //   });
  // }
  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: MapboxMap(
            accessToken: accessToken, //dotenv.env['MAPBOX_ACCESS_TOKEN'],
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            // minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
          ),
        ),
        Container(
          alignment: Alignment(-0.9, 0),
          child: FloatingActionButton(
            heroTag: "btn1",
            child: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () async {
              _addRoute();
            },
          ),
        ),
        Container(
          alignment: Alignment(-0.5, 0),
          child: FloatingActionButton(
            heroTag: "btn2",
            child: Icon(Icons.remove, color: Colors.white),
            onPressed: () async {
              _addRoute();
            },
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Align(
        //     alignment: Alignment(0, 0.9),
        //     child: Container(
        //         width: 200,
        //         height: 50,
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(15.0)),
        //         child: Align(
        //           alignment: Alignment.center,
        //           child: Text(totalDistance, style: TextStyle(fontSize: 25.0)),
        //         )),
        //   ),
        // ),
      ],
    ));
  }

  _onStyleLoadedCallback() async {
    //! Add markers here
  }

  Future<void> setFills(dynamic routeResponse) async {
    _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "geometry": routeResponse,
        },
      ],
    };
  }

  // TODO: Add List<LatLng> poits in method header
  _addRoute() async {
    if (isRouteDisplayed == false) {
      manager = RouteManager();
      routeResponse = await manager.getDirections(points[0], points[3]);

      setFills(routeResponse['geometry']);
      addFills();
      isRouteDisplayed = true;
    } else {
      removeFills();
      isRouteDisplayed = false;
    }
  }

  void addFills() async {
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

  void removeFills() async {
    await controller.removeLayer("lines");
    await controller.removeSource("fills");
  }

  Future<List<PolylineResult>> getJurneyResult(List<LatLng> journey) async {
    List<PolylineResult> results = [];
    if (journey.length > 1) {
      for (int i = 0; i < journey.length - 1; ++i) {
        results.add(await polylinePoints.getRouteBetweenCoordinates(
          googleMapsApi,
          PointLatLng(journey[i].latitude, journey[i].longitude),
          PointLatLng(journey[i + 1].latitude, journey[i + 1].longitude),
          travelMode: TravelMode.bicycling,
        ));
      }
    }
    return results;
  }

  _getPolyline(List<LatLng> _journey) async {
    List<PolylineResult> journey = await getJurneyResult(_journey);
    if (journey.isNotEmpty) {
      journey.forEach((subJurney) {
        List<PointLatLng> points = subJurney.points;
        if (points.isNotEmpty) {
          points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }
      });
    }
  }

  void clearDirections() {
    polylineCoordinates = [];
    polylinePoints = PolylinePoints();
  }
}

// TODO: Multistops

// TODO: Change camera zoom to midpoint between the given points

// TODO: Refactor

// TODO: when user doesn't have internet don't error message + cancle quries
