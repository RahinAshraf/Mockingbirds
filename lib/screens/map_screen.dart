import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../.env.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
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

  late Future<List<DockingStation>> future_docks;
  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
    onClose();
  }
  Future<void> onClose() async {
    await FirebaseFirestore.instance.collection('users').doc("WXf3P3KWFmZpOm0sazFIPJpjY2K2").set(
        {
          'firstName': 'liliannaaa'
        });
    print("called\n");
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    print("user: " + user.id + "\n");
    var group = await FirebaseFirestore.instance
        .collection('group')
        .where('code', isEqualTo: user.data()!['group'])
        .get();
    group.docs.forEach((element) {
      Timestamp timestamp = element.data()['createdAt'];
      if(DateTime.now().difference(timestamp.toDate()) > Duration(days: 1)) {
        element.reference.delete();
        FirebaseFirestore.instance.collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'group': null
        },SetOptions(merge: true));
      }
    });
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    fetchDockingStations();
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
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

  MapboxMap buildMap() {
    return MapboxMap(
      accessToken: MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
    );
  }

//This is just for testing purposes to see the docking station carousel:
  var _dockingStationCarousel = dockingStationCarousel();

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: buildMap()),

            //Container(child: _dockingStationCarousel.buildCarousel()),

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
