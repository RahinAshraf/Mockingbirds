import 'package:flutter/material.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/place_search_screen.dart';
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


  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
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
                      builder: (context) => PlaceSearchScreen(LocationService())));
                  print("This btn is to the search location screen. There is a screen in the design that comes before the search location screen so it is accessible from here for now");
                },
              ),
            ],
          ),
        ),
    floatingActionButton: FloatingActionButton(
      heroTag: "btn1",
        onPressed: () {
          controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
      child: const Icon(Icons.my_location),
      ),
    );
  }
}
