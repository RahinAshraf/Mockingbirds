import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:location/location.dart';
import 'package:veloplan/screens/location_service.dart';

const double cameraZoom = 17;
const double cameraTilt = 80;
const double cameraBearing = 30;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MapPage> {
  final String key = "AIzaSyB7YSQkjjqm-YU1LAz91lyYAvCpqFRhFdU";
  Set<Marker> _markers = Set<Marker>();
  GoogleMapController? _googleController;
  Location _currentLocation = Location();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void showUsersCurrentLocationOnMap() async {
    var location = await _currentLocation.getLocation();
    _currentLocation.onLocationChanged.listen((LocationData loc){
      _googleController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: cameraZoom,
      )));
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialCameraPosition = CameraPosition(
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
        target: LatLng(51.51185004458236,-0.11580820118980878),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Google maps"),),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: "Search for a location"),
                      onChanged: (value) { LocationService().findPlace(value); },
                    )
                ),
                IconButton(
                    onPressed: () {
                    LocationService().getPlace(_searchController.text);
                    },
                    icon: const Icon(Icons.search)
                  )
                ],
              ),
            Expanded(
                child: GoogleMap(
                  zoomControlsEnabled: true,
                  myLocationEnabled :true,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller){
                    _googleController = controller;
                    showUsersCurrentLocationOnMap();
                  },
                  markers: _markers,
                ),
              ),
            ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              print("When the user presses this btn, a new search box should show - to be implemented!");
            })
        ),
      );
    }
  }

