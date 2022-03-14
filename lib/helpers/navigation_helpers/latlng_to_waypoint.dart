import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

/// Helper methods related to converting LatLng to WayPoints
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723

/// Converts a single [latLng] into a WayPoint
WayPoint latLng2WayPoint(LatLng latLng, name) {
  return WayPoint(
      name: name, latitude: latLng.latitude, longitude: latLng.longitude);
}

/// Converts a list of [latLngs] into a list of WayPoint [points]
List<WayPoint> latLngs2WayPoints(List<LatLng> latLngs) {
  List<WayPoint> points = [];
  for (var i = 0; i < latLngs.length; ++i) {
    points.add(WayPoint(
        name: i.toString(),
        latitude: latLngs[i].latitude,
        longitude: latLngs[i].longitude));
  }
  return points;
}
