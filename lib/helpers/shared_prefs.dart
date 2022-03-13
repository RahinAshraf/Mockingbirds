import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/main.dart';

LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}
