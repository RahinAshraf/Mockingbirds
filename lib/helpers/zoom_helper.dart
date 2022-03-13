import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math.dart';

// import 'package:flutter_map/flutter_map.dart' as fm;
// import 'package:latlong/latlong.dart' as fm;
// import 'package:latlong2/latlong.dart' as fm;
// import 'package:dartleaf/dartleaf.dart' as fm;
// import 'package:dartleaf/dartleaf/src/latlng' as fm;
// import 'package:dartleaf/src/latlng.dart' as fm;

// as fm;

const double earthRadius = 6371000;
// fm.LatLng aa = fm.LatLng(51.514951, -0.112762);

// var bound = fm.LatLngBounds.fromArray([
//   fm.LatLng(51.514951, -0.112762),
//   fm.LatLng(51.513146, -0.115256),
//   fm.LatLng(51.511407, -0.125497),
//   fm.LatLng(51.506053, -0.130310),
//   fm.LatLng(51.502254, -0.217760),
// ]
// fm.LatLng(51.514951, -0.112762),
// fm.LatLng(51.513146, -0.115256),
// fm.LatLng(51.511407, -0.125497),
// fm.LatLng(51.506053, -0.130310),
// fm.LatLng(51.502254, -0.217760),
// );

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

Tuple2<double, double> getDeltaLatLng(LatLng a, LatLng b) {
  return Tuple2<double, double>(
      b.latitude - a.latitude, b.longitude - a.longitude);
}

LatLng getTopBound(List<LatLng> points) {
  var center = getCentroid(points);
  var furthest = getFurthestPointFromCenter(points, center);
  var delta = getDeltaLatLng(furthest, center);
  return LatLng(center.latitude + delta.item1, center.longitude + delta.item2);
}

List<LatLng> points = [
  LatLng(51.514951, -0.112762),
  LatLng(51.513146, -0.115256),
  LatLng(51.511407, -0.125497),
  LatLng(51.506053, -0.130310),
  LatLng(51.502254, -0.217760),
];
List<double> latLng2Cartesian3DVector(LatLng point) {
  var theta = radians(90 - point.latitude);
  // print("theta 1: " + theta.toString());
  var phi = radians(point.longitude);
  return [
    earthRadius * sin(theta) * cos(phi),
    earthRadius * sin(theta) * sin(phi),
    earthRadius * cos(theta)
  ];
}

LatLng cartesian3DVector2LatLng(List<double> vector) {
  var phi = degrees(atan(vector[1] / vector[0]));
  var theta = 90 -
      degrees(atan(sqrt(pow(vector[0], 2) + pow(vector[1], 2)) / vector[2]));
  var radius = sqrt(pow(vector[0], 2) + pow(vector[1], 2) + pow(vector[2], 2));
  return LatLng(theta, phi);
}

List<List<double>> latLngs2Sperical3DVectors(List<LatLng> points) {
  List<List<double>> latlongs = [[]];
  for (var p in points) {
    latlongs.add(latLng2Cartesian3DVector(p));
  }
  return latlongs;
}

List<double> getMidpointBetween2Coordinates(List<double> a, List<double> b) {
  if (a.length == 3 && b.length == 3) {
    var C = [
      (a[0] + b[0]) / 2,
      (a[1] + b[1]) / 2,
      (a[2] + b[2]) / 2,
    ];
    var L = sqrt(pow(C[0], 2) + pow(C[1], 2) + pow(C[2], 2));
    return [C[0] / L, C[1] / L, C[2] / L];
  }
  return [];
}

List<double> getMidpointsBetweenCoordinates(List<List<double>> points) {
  List<double> mid = [];
  if (points.length > 1) {
    mid = getMidpointBetween2Coordinates(points[0], points[1]);
    for (int i = 2; i < points.length - 1; i++) {
      mid = getMidpointBetween2Coordinates(mid, points[i]);
    }
  }
  return mid;
}

// main() {
// //   var a = getMidpointBetween2Coordinates(
// //       latLng2Cartesian3DVector(points[0]), latLng2Cartesian3DVector(points[3]));
// //   // print("x: " +
// //   //     a[0].toString() +
// //   //     "   y: " +
// //   //     a[1].toString() +
// //   //     "   z: " +
// //   //     a[2].toString());
// //   var b = cartesian3DVector2LatLng(a);
// //   print(b.toString());

//   // var centroid = getCentroid(points);
//   // var furthest = getFurthestPointFromCenter(points, centroid);
//   // var delta = getDeltaLatLng(furthest, centroid);
//   var deltaLatLng = getTopBound(points);
//   print(deltaLatLng.toString());

// //   // var b = latLng2Cartesian3DVector(points[0]);
// //   // var c = cartesian3DVector2LatLng(b);
// //   // // print(b.toString());
// //   // print("before: " + points[0].toString());
// //   // print("after: " + c.toString());
// //   // var b = getMidpointsBetweenCoordinates(latLngs2Sperical3DVectors(points));
// //   // print("b: " + b.toString());
// }
