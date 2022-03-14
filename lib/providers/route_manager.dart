import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:veloplan/.env.dart';

/// Route provider for fetching journey details from the  Mapbox directions API
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737

class RouteManager {
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String accessToken = MAPBOX_ACCESS_TOKEN;
  String navType = 'cycling';
  Dio _dio = Dio();
  Map<String, Object> directions = {};

  Future<Map> getDirections(
      LatLng currentLatLng, LatLng location_placeholder) async {
    final response = await getCyclingRoute(currentLatLng, location_placeholder);
    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];
    // // print(
    // //     '-------------------${location_placeholder['name']}-------------------');
    // print(distance);
    // print(duration);
    directions = {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
    };
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

  Future getWalkingRoute(LatLng source, LatLng destination) async {
    String url =
        '$baseUrl/${'walking'}/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      return responseData.data;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint(errorMessage);
    }
  }

  Object? getGeometry() {
    if (directions.isNotEmpty) {
      return directions['geometry'];
    } else {
      return null;
    }
  }

  Object? getDuration() async {
    if (directions.isNotEmpty) {
      return directions['duration'];
    } else {
      return null;
    }
  }

  Object? getDistance() async {
    if (directions.isNotEmpty) {
      return directions['distance'];
    } else {
      return null;
    }
  }

  //TODO: get geometry
  //TODO: get duration
  //TODO: get distance

  //TODO: get geometry
  //TODO: refactor cycling and walking route methods
}
