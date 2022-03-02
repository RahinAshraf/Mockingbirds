import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RouteManager {
  String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  String accessToken =
      'pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNrempyNnZtajNkbmkybm8xb3lybWE3MTIifQ.AsZJbQPNRb2N3unNdA98nQ';
  String navType = 'cycling';
  Dio _dio = Dio();

  Future<Map> getDirections(
      LatLng currentLatLng, LatLng location_placeholder) async {
    final response = await getCyclingRoute(currentLatLng, location_placeholder);
    Map geometry = response['routes'][0]['geometry'];
    num duration = response['routes'][0]['duration'];
    num distance = response['routes'][0]['distance'];
    // print(
    //     '-------------------${location_placeholder['name']}-------------------');
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

  // Future<dynamic> getGeometry() async {
  //   print("I got here!!!!!!!!!!!!!!!!!!!");
  //   print(routeResponse['geometry']);
  //   return routeResponse['geometry'];
  // }

  // dynamic getDuration() async {
  //   return routeResponse['duration'];
  // }

  // dynamic getDistance() async {
  //   return routeResponse['distance'];
  // }

  //TODO: get geometry
  //TODO: get duration
  //TODO: get distance

  //TODO: get geometry
  //TODO: refactor cycling and walking route methods 
}
