import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:veloplan/main.dart';
import 'package:latlong2/latlong.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  initializeLocation(); //Upon opening the app, store the users current location
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
  ));
}


void initializeLocation() async {
  Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled = await _location.requestService();
  }

  _permissionGranted = await _location.hasPermission();
  if(_permissionGranted == PermissionStatus.denied){
    _permissionGranted = await _location.requestPermission();
  }

  LocationData _locationData = await _location.getLocation();
  LatLng currentLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);

  saveLocation(_locationData);
}

void saveLocation(LocationData _locationData){
  sharedPreferences.setDouble('latitude', _locationData.latitude!);
  sharedPreferences.setDouble('longitude', _locationData.longitude!);
}