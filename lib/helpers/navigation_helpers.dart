import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';

double calculateDistance(LatLng pos1, LatLng pos2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((pos2.latitude - pos1.latitude) * p) / 2 +
      cos(pos1.latitude * p) *
          cos(pos2.latitude * p) *
          (1 - cos((pos2.longitude - pos1.longitude) * p)) /
          2;
  return 12742 * asin(sqrt(a));
}

List<LatLng> sortByDistance(LatLng start, List<LatLng> points) {
  points.sort((a, b) => calculateDistance(start, a)
      .compareTo(calculateDistance(start, b).toDouble()));
  return points;
}

double distanceCalulator(List<LatLng> points) {
  double totalDistance = 0.0;
  for (int i = 0; i < points.length - 1; ++i) {
    totalDistance += calculateDistance(points[i], points[i + 1]);
  }
  return totalDistance;
}

LatLng getCentroid(List<LatLng> points) {
  double lat = 0;
  double lng = 0;
  int n = points.length;

  for (LatLng point in points) {
    lat += point.latitude;
    lng += point.longitude;
  }

  return LatLng(lat / n, lng / n);
}

double getRadius(List<LatLng> points, LatLng center) {
  double max = 0;
  for (LatLng point in points) {
    double dist = calculateDistance(center, point);
    if (dist > max) {
      max = dist;
    }
  }
  return max;
}

double getZoom(double radius) {
  return log(2048 / radius * 350);
}
