import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../.env.dart';
import 'package:veloplan/screens/location_service.dart';

const double zoom = 16;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;

  TextEditingController _searchController = TextEditingController();

  late List<DockingStation> docking_stations;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    fetchDockingStations();
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations))
        .then((value) => initialiseStations(_stationManager));
  }

  void initialiseStations(dockingStationManager _stationManager) {
    docking_stations = _stationManager.stations;
    List<DockingStation> closest_dock_to_user_location =
        _stationManager.get5ClosestAvailableDockingStationsToGetBikes(
            getLatLngFromSharedPrefs(), _stationManager.stations, 21);
  }

  void placeDockMarkers(List<DockingStation> docks) {
    setState(() {
      for (var station in docks) {
        _markers.add(Marker(
            point: LatLong.LatLng(station.lat, station.lon),
            builder: (_) {
              return _buildCustomMarker();
            }));
      }
    });
  }

  Container _buildCustomMarker() {
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
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: MapboxMap(
                accessToken: MAPBOX_ACCESS_TOKEN,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
              ),
            ),

            //PLACEHOLDER FAB
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PlaceSearchScreen(LocationService())));
                print(
                    "This btn is to the search location screen. There is a screen in the design that comes before the search location screen so it is accessible from here for now");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
