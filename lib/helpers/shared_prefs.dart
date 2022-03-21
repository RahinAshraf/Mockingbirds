import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/live_location_helper.dart';

LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude') ?? 51.50210895979394,
      sharedPreferences.getDouble('longitude') ?? -0.12486400015650483);
}
