import 'dart:convert';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/main.dart';
import 'package:veloplan/helpers/live_location_helper.dart';


LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

