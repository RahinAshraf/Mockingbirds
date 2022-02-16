import 'package:flutter/material.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../.env.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../helpers/navigation_helpers.dart';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  late Future<List<DockingStation>> future_docks;
  Set<Marker> _markers = Set<Marker>();

  var zoom = LatLng(51.51185004458236, -0.11580820118980878);
  String googleMapsApi = 'AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU';

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  List<LatLng> points = [
    LatLng(51.514951, -0.112762),
    LatLng(51.513146, -0.115256),
    LatLng(51.511407, -0.125497),
    LatLng(51.506053, -0.130310)
  ];

  String totalDistance = 'No route';

  @override
  void initState() {
    super.initState();
    fetchDockingStations();
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
  }

  void placeDockMarkers(List<DockingStation> docks) {
    int i = 0;
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
                    image: NetworkImage(
                        'https://www.iconpacks.net/icons/1/free-icon-bicycle-1054.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }));
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
              center: zoom,
              zoom: 14.0,
              minZoom: 5,
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
                markers: _markers.toList()
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
              PolylineLayerOptions(polylines: [
                Polyline(
                    points: polylineCoordinates, // points
                    strokeWidth: 5.0,
                    color: Colors.red)
              ])
            ],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment(0, 0.9),
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
        ),
      ],
    ));
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
    setDistance();
  }

  void clearDirections() {
    polylineCoordinates = [];
    polylinePoints = PolylinePoints();
  }

  void setDistance() {
    setState(() {
      totalDistance = distanceCalulator(polylineCoordinates).toString();
    });
  }
}


// TODO: use mapbox direction api instead
// * https://www.youtube.com/watch?v=oFDx6tLipmw

// TODO: Change camera zoom to midpoint between the given points


// TODO: when user doesn't have internet don't error message + cancle quries