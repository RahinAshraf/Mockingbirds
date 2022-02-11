import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../screens/login_screen.dart';
import '../navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../.env.dart';

class MapPage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MapPage> {
  Location _currentLocation = Location();
  late double currentLatitude;
  late double currentLongitude;
  MapController? _mapController;
  bool hasOpened = false;

  @override
  void initState() {
    super.initState();
    showUsersCurrentLocationOnMap();
  }

  void showUsersCurrentLocationOnMap() async {
    var location = await _currentLocation.getLocation();
    _currentLocation.onLocationChanged.listen((LocationData loc) {
        currentLatitude = loc.latitude ?? 0.0;
        currentLongitude = loc.longitude ?? 0.0;
        print("SUIIII");
        print(currentLatitude);
        print(currentLongitude);

        _mapController?.move(latLng.LatLng(loc.latitude ?? 0.0 , loc.longitude ?? 0.0), 15); //moves the camera to the users live location
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
              onMapCreated: (MapController controller) {
                _mapController = controller;
              },
              center: latLng.LatLng(51.51324313368016, -0.1174160748370747),
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
                markers: [
                  Marker(
                      point: latLng.LatLng(51.51324313368016, -0.1174160748370747),
                      builder: (_) {
                        return Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
        Container(
            alignment: Alignment(-0.9, -0.5),
            child: FloatingActionButton(
                heroTag: "btn2",
                child: Icon(Icons.location_searching, color: Colors.white),
                backgroundColor: Colors.green,
                onPressed: showUsersCurrentLocationOnMap)),
      ],
    ));
  }
}
