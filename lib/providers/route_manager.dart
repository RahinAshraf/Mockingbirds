import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/utilities/enums.dart/travel_type.dart';

/// Route provider for fetching journey details from the  Mapbox directions API
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737

class RouteManager {
  final String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _accessToken = MAPBOX_ACCESS_TOKEN;
  final Dio _dio = Dio();
  Map<String, Object> _directions = {};

  /// populate directions map with route information
  Future<Map<String, dynamic>> getDirections(LatLng currentLatLng,
      LatLng location_placeholder, NavigationType navigationType) async {
    final response =
        await getRoute(currentLatLng, location_placeholder, navigationType);
    _directions = {
      "geometry": response['routes'][0]['geometry'],
      "duration": response['routes'][0]['duration'],
      "distance": response['routes'][0]['distance'],
    };
    return _directions;
  }

  /// gets the current route information from the directions API
  Future getRoute(
      LatLng source, LatLng destination, NavigationType navigationType) async {
    String type = getNavigationType(navigationType);
    if (type.isEmpty) {
      return null;
    }
    String url =
        '$_baseUrl/$type/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$_accessToken';
    try {
      _dio.options.contentType = Headers.jsonContentType;
      final responseData = await _dio.get(url);
      return responseData.data;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint(errorMessage);
    }
  }

  /// gets the geometry of the current route
  Object? getGeometry() {
    if (_directions.isNotEmpty) {
      return _directions['geometry'];
    } else {
      return null;
    }
  }

  /// gets the duration of the current route
  Object? getDuration() async {
    if (_directions.isNotEmpty) {
      return _directions['duration'];
    } else {
      return null;
    }
  }

  /// gets the distance of the current route
  Object? getDistance() async {
    if (_directions.isNotEmpty) {
      return _directions['distance'];
    } else {
      return null;
    }
  }

  /// sets the [geometry] of the current route
  void setGeometry(Object geometry) {
    _directions['geometry'] = geometry;
  }

  /// sets the [duration] of the current route
  void setDuration(double duration) async {
    _directions['duration'] = duration;
  }

  /// sets the [distance] of the current route
  void setDistance(double distance) async {
    _directions['distance'] = distance;
  }
}
