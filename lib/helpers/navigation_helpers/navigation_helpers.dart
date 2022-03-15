import 'dart:math';
// import 'package:latlong2/latlong.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';

/// Helper methods related to map navigation
/// Author(s): Elisabeth Koren Halvorsen k20077737

const double earthRadiusInMeters = 6371000;
const double earthRadiusInKm = 6371;

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

/// Gets the midpoint between point [a] and [b], Will only work for close distances
LatLng getMidpoint(LatLng a, LatLng b) {
  return LatLng((a.latitude + b.latitude) / 2, (a.longitude + b.longitude) / 2);
}

/// gets the bottom left corner and the top right corner from a list of [points].
/// returns in order [bottomLeft, topRight]
Tuple2<LatLng, LatLng> getCornerCoordinates(List<LatLng> points) {
  double smallestLat = points[0].latitude;
  double greatestLat = points[0].latitude;
  double smallestLng = points[0].longitude;
  double greatestLng = points[0].longitude;
  for (int i = 1; i < points.length; ++i) {
    var current = points[i];
    if (smallestLat > current.latitude) smallestLat = current.latitude;
    if (greatestLng < current.latitude) greatestLat = current.latitude;
    if (smallestLng > current.longitude) smallestLng = current.longitude;
    if (greatestLng < current.longitude) greatestLng = current.longitude;
  }
  return Tuple2(
      LatLng(smallestLat, greatestLng), LatLng(greatestLat, smallestLng));
}

/// gets the center from [points]
LatLng getCenter(List<LatLng> points) {
  var corners = getCornerCoordinates(points);
  return getMidpoint(corners.item1, corners.item2);
}

/// gets the zoom factor from [radius]
double getZoom(double radius) {
  double x = (2 * pi * earthRadiusInKm) / (2 * radius);
  double log2 = log(x) / log(2);
  return log2 / 1.125;
}
