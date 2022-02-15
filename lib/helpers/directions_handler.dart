// //import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/main.dart';

import '../constants/locations_placeholder.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
  final response = await getCyclingRouteUsingMapbox(
      currentLatLng,
      LatLng(
          double.parse(locations_placeholder[index]['coordinates']['latitude']),
          double.parse(
              locations_placeholder[index]['coordinates']['longitude'])));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  print(
      '-------------------${locations_placeholder[index]['name']}-------------------');
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('locations--$index', response);
}
