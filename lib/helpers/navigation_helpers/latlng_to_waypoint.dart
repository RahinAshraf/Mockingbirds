/// @author Elisabeth Halvorsen, Fariha Choudhury
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

WayPoint latLng2WayPoint(LatLng latLng, name) {
  return WayPoint(
      name: name, latitude: latLng.latitude, longitude: latLng.longitude);
}

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
