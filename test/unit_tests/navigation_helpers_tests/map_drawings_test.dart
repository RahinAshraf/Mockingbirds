import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Tests for map_drawings.dart (only setFills can be tested using automated tests - see manual testing for more)
/// Author(s):  Fariha Choudhury k20059723

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  sharedPreferences = await SharedPreferences.getInstance();
  final RouteManager _manager = RouteManager();

  List<LatLng> prettyCoords = [
    const LatLng(-50, 1),
    const LatLng(-51, -1),
    const LatLng(-50.5, 0)
  ];
  Map<String, dynamic> _fills = {};
  Map _routeResponse = await _manager.getDirections(
      prettyCoords[0], prettyCoords[1], NavigationType.cycling);

  testWidgets("Mapbox", (WidgetTester tester) async {
    MapboxGlPlatform stuff = MapboxGlPlatform.createInstance.call();
    MapboxMapController controller = new MapboxMapController(
        mapboxGlPlatform: stuff,
        initialCameraPosition:
            CameraPosition(target: LatLng(-50, 1), zoom: 15));
    var mapboxMap = tester.firstWidget(find.byType(MapboxMap)) as MapboxMap;
    mapboxMap.onMapCreated!(controller);
    mapboxMap.onStyleLoadedCallback!();

    tester.binding.scheduleWarmUpFrame();
  });

  test('setFills populates a Map with geometries', () async {
    _fills = await setFills(_fills, _routeResponse);
    expect(_fills.isNotEmpty, true);
  });

  test(
      'setFills populates a Map with geometries with the correct _routeResponse geometries',
      () async {
    _fills = await setFills(_fills, _routeResponse);
    var coords = _routeResponse['geometry']!['coordinates'];
    expect(_fills['features'][0]['geometry'], _routeResponse);
    expect(
        _fills['features'][0]['geometry']['geometry']['coordinates'], coords);
  });

  test('setFills with an empty _routeResponse produces an empty map', () async {
    _fills = await setFills(_fills, <dynamic, dynamic>{});
    expect(_fills['features'][0]['geometry'], {});
  });
}
