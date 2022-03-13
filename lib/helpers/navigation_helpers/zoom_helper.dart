import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math.dart';

/// Helper methods related to map zooming
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723

/// gets the zoom factor from [radius]
double getZoom(double radius) {
  return log(2048 / radius * 350);
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
