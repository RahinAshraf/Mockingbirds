// import 'dart:html';
import 'dart:async';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/screens/navigation/map_with_route_screen.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';

/// Map screen focused on a user's live location
/// Author(s): Elisabeth Halvorsen k20077737

class MapWithRouteUpdated extends BaseMapboxRouteMap {
  MapWithRouteUpdated(List<LatLng> journey, MapModel model)
      : super(journey, model);
  LatLng _target = getLatLngFromSharedPrefs();
  Timer? timer;

  @override
  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    LatLng _target =
        LatLng(_newLocationData.latitude!, _newLocationData.longitude!);
    print("lat: " +
        _newLocationData.latitude!.toString() +
        "  ,lng: " +
        _newLocationData.longitude!.toString());
  }

  void onMapCreated(MapboxMapController controller) async {
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => updateCurrentLocation());
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => _updateCameraPosition());
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: _target, zoom: 15);
    print("camera position updated!");
  }

  // @override
  // void _displayJourneyAndRefocus(List<LatLng> journey) {
  //   _setJourney(journey);
  //   _refocusCamera(journey);
  //   setPolylineMarkers(controller!, journey, _polylineSymbols);
  // }
}


///TODO: update subsection of journey every 2 second
///TODO: Check endpoints if still avalible -> help Nicole/Lili