import 'dart:math';
// import 'package:latlong2/latlong.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:vector_math/vector_math.dart';

const double earthRadius = 6371000;

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

LatLng getFurthestPointFromCenter(List<LatLng> points, LatLng center) {
  double max = 0;
  LatLng maxPoint = LatLng(0, 0);

  for (LatLng point in points) {
    double dist = calculateDistance(center, point);
    if (dist > max) {
      maxPoint = point;
    }
  }
  return maxPoint;
}

double getRadius(List<LatLng> points, LatLng center) {
  double max = 0;
  for (LatLng point in points) {
    double dist = calculateDistance(center, point);
    if (dist > max) {
      // print(point);
      // print("max lat: " +
      //     point.latitude.toString() +
      //     "     max lng: " +
      //     point.longitude.toString());
      max = dist;
    }
  }
  // print("max latlng: " + max.toString());
  return max;
}

double getZoom(double radius) {
  return log(2048 / radius * 350);
}

LatLng getCenter(LatLng a, LatLng b) {
  // var t1 = radians(a.latitude);
  // var t2 = radians(b.latitude);
  // var l1 = radians(a.longitude);
  // var l2 = radians(b.longitude);
  // var bx = cos(t2) * cos(l2 - l1);
  // var by = cos(t2) * sin(l2 - l1);
  // var theta =
  //     atan2(sin(t1) + sin(t2), sqrt(cos(t1 + bx) * cos(t1 + bx) + by * by));
  // var lambda = l1 + atan2(by, cos(t1) + bx);
  // return LatLng(degrees(theta), degrees(lambda));
  return LatLng((a.latitude + b.latitude) / 2, (a.longitude + b.longitude) / 2);
}

// λ = longitude
// ϕ = latitude
double getBearing(LatLng a, LatLng b) {
  var y = sin(b.longitude - a.longitude) * cos(b.latitude);
  var x = cos(a.latitude) * sin(b.latitude) -
      sin(a.latitude) * cos(b.latitude) * cos(b.longitude - a.longitude);
  var theta = atan2(y, x);
  // return 14;
  return (theta * 180 / pi) % 360;
}
