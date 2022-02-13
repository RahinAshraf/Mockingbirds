import 'package:mapbox_gl/mapbox_gl.dart';

//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart';
import '../constants/locations_placeholder.dart';

LatLng getLatLngFromRestaurantData(int index) {
  return LatLng(
      double.parse(locations_placeholder[index]['coordinates']['latitude']),
      double.parse(locations_placeholder[index]['coordinates']['longitude']));
}
