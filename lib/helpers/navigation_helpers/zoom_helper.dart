import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math.dart';

/// Helper methods related to map zooming
/// Author(s): Elisabeth Koren Halvorsen k20077737

const double earthRadius = 6371; //000;

/// gets the zoom factor from [radius]
double getZoom(double radius) {
  double x = (2 * pi * earthRadius) / (2 * radius);
  double log2 = log(x) / log(2);
  return log2 / 1.125;
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
