import 'dart:math';
import 'package:latlong2/latlong.dart';

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
  return round(totalDistance, decimals: 2);
}
