// import 'dart:html';
import 'dart:async';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
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
  late List<LatLng> _journey;
  bool check = true;
  MapWithRouteUpdated(List<LatLng> journey, MapModel model)
      : super(journey, model) {
    this._journey = journey;
  }
  LatLng _target = getLatLngFromSharedPrefs();
  Timer? timer;
  final Set<Symbol> _polylineSymbols = {};

  @override
  void updateCurrentLocation() async {
    Location newCurrentLocation = Location();
    LocationData _newLocationData = await newCurrentLocation.getLocation();
    sharedPreferences.clear();
    sharedPreferences.setDouble('latitude', _newLocationData.latitude!);
    sharedPreferences.setDouble('longitude', _newLocationData.longitude!);
    _target = LatLng(_newLocationData.latitude!, _newLocationData.longitude!);
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
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => updateRoute());

    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    _displayJourneyAndRefocus(_journey);
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  void _updateCameraPosition() {
    cameraPosition = CameraPosition(target: _target, zoom: 15);
    print("camera position updated!");
  }

  void updateRoute() {
    //! check new if we need to reroute here if yes then we update
    check = false;
    removePolylineMarkers(controller!, _journey, _polylineSymbols);
    removeFills(controller, _polylineSymbols, fills);
    print("updating route");
    _journey = [
      _target,
      LatLng(51.513146, -0.115256),
      LatLng(51.511407, -0.125497),
    ];
    _displayJourneyAndRefocus(_journey);
  }

  @override
  void _displayJourneyAndRefocus(List<LatLng> journey) {
    setJourney(journey);
    _updateCameraPosition();
    setPolylineMarkers(controller!, journey, _polylineSymbols);
  }
}

/// TODO: if within 50m of target then remove from _journey
///TODO: Check endpoints if still avalible -> help Nicole/Lili