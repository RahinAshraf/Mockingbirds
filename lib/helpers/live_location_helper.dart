import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

late SharedPreferences sharedPreferences;

class LiveLocationHelper{

  void initializeLocation() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    LocationData _locationData = await _location.getLocation();
    LatLng currentLatLng =
    LatLng(_locationData.latitude!, _locationData.longitude!);

    saveLocation(_locationData);
  }

  void saveLocation(LocationData _locationData) {
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
  }

}