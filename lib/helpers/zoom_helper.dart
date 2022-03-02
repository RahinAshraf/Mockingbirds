import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:vector_math/vector_math.dart';

const double earthRadius = 6371000;

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

    print("long: " + degrees(pi / 2 - atan2(C[0], C[1])).toString());
    var hyp = sqrt(pow(C[0], 2) + pow(C[1], 2));
    print("lat: " + degrees(atan2(C[2], hyp)).toString());
    var l = [b[0] - a[0], b[1] - a[1], b[2] - a[2]];
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

main() {
  var a = getMidpointBetween2Coordinates(
      latLng2Cartesian3DVector(points[0]), latLng2Cartesian3DVector(points[3]));
  // print("x: " +
  //     a[0].toString() +
  //     "   y: " +
  //     a[1].toString() +
  //     "   z: " +
  //     a[2].toString());
  var b = cartesian3DVector2LatLng(a);
  print(b.toString());

  // var b = latLng2Cartesian3DVector(points[0]);
  // var c = cartesian3DVector2LatLng(b);
  // // print(b.toString());
  // print("before: " + points[0].toString());
  // print("after: " + c.toString());
  // var b = getMidpointsBetweenCoordinates(latLngs2Sperical3DVectors(points));
  // print("b: " + b.toString());
}
