import 'package:mapbox_gl/mapbox_gl.dart';

import '../constants/locations_placeholder.dart';

LatLng getLatLngFromLocationData(int index) {
  return LatLng(
      double.parse(locations_placeholder[index]['coordinates']['latitude']),
      double.parse(locations_placeholder[index]['coordinates']['longitude']));
}
