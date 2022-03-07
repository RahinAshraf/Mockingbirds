import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math.dart';

/// Helper methods related to map zooming
/// Author(s): Elisabeth Koren Halvorsen k20077737

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

/// zoom [cameraPosition] in via the [controller]
CameraPosition zoomIn(
    CameraPosition _cameraPosition, MapboxMapController? controller) {
  _cameraPosition = CameraPosition(
      target: _cameraPosition.target,
      zoom: _cameraPosition.zoom + 0.5,
      tilt: 5);
  controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  return _cameraPosition;
}

/// zoom [cameraPosition] out via the [controller]
CameraPosition zoomOut(
    CameraPosition cameraPosition, MapboxMapController? controller) {
  cameraPosition = CameraPosition(
      target: cameraPosition.target, zoom: cameraPosition.zoom - 0.5, tilt: 5);
  controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  return cameraPosition;
}
