import 'package:flutter_test/flutter_test.dart';
import 'package:geocode/geocode.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/utilities/enums.dart/travel_type.dart';

/// Unit tests for route_manager.dart and travel_type.dart
/// Author: Fariha Choudhury k20059723

void main() {
  final RouteManager _manager = RouteManager();
  final RouteManager _manager2 = RouteManager();
  late Map _routeResponse;
  List<LatLng> journey = [
    const LatLng(51.514951, -0.112762),
    const LatLng(51.513146, -0.115256),
    const LatLng(51.511407, -0.125497),
    const LatLng(51.506053, -0.130310),
    const LatLng(51.502254, -0.217760),
  ];

  late Object? geometry;

  setUp(() {
    _manager2.getDirections(journey[2], journey[3], NavigationType.cycling);
    geometry = _manager2.getGeometry();
  });

  /// Returns [true] if [enumeratedValue] is an Enumerated Type
  bool isEnum(dynamic enumeratedValue) {
    final splitEnum = enumeratedValue.toString().split('.');
    return splitEnum.length > 1 &&
        splitEnum[0] == enumeratedValue.runtimeType.toString();
  }

  /// Range check is used as route data depends on live traffic and road works
  bool checkInRange(double result, double expected) {
    if (result < expected + 15 && result > expected - 15) {
      return true;
    } else {
      return false;
    }
  }

  test('getDirections for walking route creates a Map', () async {
    _routeResponse = await _manager.getDirections(
        journey[0], journey[1], NavigationType.walking);

    expect(_routeResponse.isEmpty, false);
    expect(checkInRange(_routeResponse['distance'], 511.797), true);
    expect(checkInRange(_routeResponse['duration'], 376.207), true);
  });

  test('getDirections for cycling route creates a Map', () async {
    _routeResponse = await _manager.getDirections(
        journey[0], journey[1], NavigationType.cycling);

    expect(_routeResponse.isEmpty, false);
    expect(checkInRange(_routeResponse['distance'], 510.9), true);
    expect(checkInRange(_routeResponse['duration'], 234.1), true);
  });

  test(
      'getRoute for walking route produces a response with corresponding geometry, distance and duration',
      () async {
    final response =
        await _manager.getRoute(journey[3], journey[4], NavigationType.walking);
    expect(response.isEmpty, false);
    expect(response['routes'][0]['geometry']['coordinates'][0],
        [-0.130317, 51.506059]);
    expect(checkInRange(response['routes'][0]['distance'], 6791.35), true);
    expect(checkInRange(response['routes'][0]['duration'], 4799.211), true);
  });
  test(
      'getRoute for cycling route produces a response with corresponding geometry, distance and duration',
      () async {
    final response =
        await _manager.getRoute(journey[3], journey[4], NavigationType.cycling);
    expect(response.isEmpty, false);
    expect(response['routes'][0]['geometry']['coordinates'][0],
        [-0.130317, 51.506059]);
    expect(checkInRange(response['routes'][0]['distance'], 7543.4), true);
    expect(checkInRange(response['routes'][0]['duration'], 2100.6), true);
  });

  group('get geometry, distance and duration for walking and cycling ', () {
    test('getGeometry returns correct information', () async {
      var _walkingResponse = await _manager.getDirections(
          journey[1], journey[2], NavigationType.walking);
      var walkingGeometry = _walkingResponse['geometry'];
      expect(await _manager.getGeometry(), walkingGeometry);
    });

    test(
        'getDistance for cycling and walking route returns correct information',
        () async {
      var _walkingResponse = await _manager.getDirections(
          journey[0], journey[1], NavigationType.walking);
      var walkingDistance = _walkingResponse['distance'];
      expect(await _manager.getDistance(), walkingDistance);
    });

    test(
        'getDuration for cycling and walking route returns correct information',
        () async {
      var _walkingResponse = await _manager.getDirections(
          journey[0], journey[1], NavigationType.walking);
      var walkingDuration = _walkingResponse['duration'];
      expect(await _manager.getDuration(), walkingDuration);
    });

    test(
        'getGeometry returns correct information for directions to the same point by walking ',
        () async {
      var _walkingResponse = await _manager.getDirections(
          journey[1], journey[1], NavigationType.walking);
      Map walkingGeometry = _walkingResponse['geometry'];
      Map getGeometryMap = await _manager.getGeometry() as Map;
      expect(getGeometryMap['coordinates'], [
        [-0.115257, 51.513144],
        [-0.115257, 51.513144]
      ]);
      expect(walkingGeometry['coordinates'], [
        [-0.115257, 51.513144],
        [-0.115257, 51.513144]
      ]);
      expect(getGeometryMap['coordinates'], walkingGeometry['coordinates']);
    });

    test(
        'getGeometry returns correct information for directions to the same point by cycling ',
        () async {
      var _cyclingResponse = await _manager.getDirections(
          journey[1], journey[1], NavigationType.cycling);
      Map cyclingGeometry = _cyclingResponse['geometry'];
      Map getGeometryMap = await _manager.getGeometry() as Map;
      expect(getGeometryMap['coordinates'], [
        [-0.115256, 51.513145],
        [-0.115256, 51.513145]
      ]);
      expect(cyclingGeometry['coordinates'], [
        [-0.115256, 51.513145],
        [-0.115256, 51.513145]
      ]);
      expect(getGeometryMap['coordinates'], cyclingGeometry['coordinates']);
    });

    test(
        'getDistance for cycling and walking route returns 0 for two same points',
        () async {
      var _cyclingResponse = await _manager.getDirections(
          journey[0], journey[0], NavigationType.cycling);
      var cyclingDistance = _cyclingResponse['distance'];
      expect(await _manager.getDistance(), cyclingDistance);
      expect(await _manager.getDistance(), 0);
      expect(cyclingDistance, 0);
      _manager.setDistance(0);
      var _walkingResponse = await _manager.getDirections(
          journey[0], journey[0], NavigationType.walking);
      var walkingDistance = _walkingResponse['distance'];
      expect(await _manager.getDistance(), walkingDistance);
      expect(await _manager.getDistance(), 0);
      expect(walkingDistance, 0);
    });

    test(
        'getDuration for cycling and walking route returns 0 for two same points',
        () async {
      var _cyclingResponse = await _manager.getDirections(
          journey[0], journey[0], NavigationType.cycling);
      var cyclingDuration = _cyclingResponse['duration'];
      expect(await _manager.getDuration(), cyclingDuration);
      expect(await _manager.getDuration(), 0);
      expect(cyclingDuration, 0);
      _manager.setDuration(0);
      var _walkingResponse = await _manager.getDirections(
          journey[0], journey[0], NavigationType.walking);
      var walkingDuration = _walkingResponse['duration'];
      expect(await _manager.getDuration(), walkingDuration);
      expect(await _manager.getDuration(), 0);
      expect(walkingDuration, 0);
    });
  });

  group('set geometry, distance and duration for walking and cycling ', () {
    test('setGeometry stores geometry', () async {
      _manager.setGeometry(geometry!);
      expect(await _manager.getGeometry(), geometry);
    });

    test('setDistance stores distance', () async {
      _manager.setDistance(7.8);
      expect(await _manager.getDistance(), 7.8);
    });
    test('setDuration stores duration', () async {
      _manager.setDuration(5.6);
      expect(await _manager.getDuration(), 5.6);
    });
  });

  group('enumerated types for navigation', () {
    test('navigation type walking returns String walking', () async {
      expect(getNavigationType(NavigationType.walking), 'walking');
    });

    test('navigation type cycling returns String cycling', () async {
      expect(getNavigationType(NavigationType.cycling), 'cycling');
    });

    test('navigation type walking returns Enumerated type', () async {
      expect(isEnum(NavigationType.walking), true);
    });

    test('navigation type cycling  returns Enumerated type', () async {
      expect(isEnum(NavigationType.cycling), true);
    });
  });
}
