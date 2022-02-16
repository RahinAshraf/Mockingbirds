import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RouteManager {
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  String navType = 'cycling';
  Dio _dio = Dio();

  Future<Map> getDirections(
      LatLng currentLatLng, Map location_placeholder) async {
    final response = await getCyclingRoute(
        currentLatLng,
        LatLng(double.parse(location_placeholder['coordinates']['latitude']),
            double.parse(location_placeholder['coordinates']['longitude'])));
    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];
    print(
        '-------------------${location_placeholder['name']}-------------------');
    print(distance);
    print(duration);
    return {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
    };
  }

  Future getCyclingRoute(LatLng source, LatLng destination) async {
    String url =
        '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      return responseData.data;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint(errorMessage);
    }
  }
}
