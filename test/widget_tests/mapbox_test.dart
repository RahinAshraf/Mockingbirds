import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/models/map_models/base_map_station_model.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';

/// Tests for map_models
/// Author(s):  Fariha Choudhury k20059723

Future<void> main() async {
  SharedPreferences.setMockInitialValues({});
  sharedPreferences = await SharedPreferences.getInstance();
  final StreamController<MapPlace>? address = StreamController.broadcast();
  List<LatLng> prettyCoords = [
    const LatLng(-50, 1),
    const LatLng(-51, -1),
    const LatLng(-50.5, 0)
  ];

  final MapModel _model = MapModel();
  final BaseMapboxMap baseMap = BaseMapboxMap(_model);
  final BaseMapboxMap baseMapWithClick =
      BaseMapboxMap(_model, address: address);
  // final BaseMapboxRouteMap baseRouteMap =
  //     BaseMapboxRouteMap(prettyCoords, _model);
  final BaseMapboxStationMap baseStationMap =
      BaseMapboxStationMap(prettyCoords, prettyCoords[1], _model);

  final mapPage = MapPage();
  // MapboxGlPlatform stuff = MapboxGlPlatform.createInstance.call();
  // MapboxMapController controller = new MapboxMapController(
  //     mapboxGlPlatform: stuff,
  //     initialCameraPosition: CameraPosition(target: LatLng(-50, 1), zoom: 15));

  testWidgets("Mapbox base map", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Center(
          child: Stack(
        children: [baseMap.map],
      )),
    )));
    expect(find.byType(MapboxMap), findsOneWidget);
  });

  testWidgets("Mapbox base map with click", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Center(
          child: Stack(
        children: [baseMapWithClick.map],
      )),
    )));

    expect(find.byType(MapboxMap), findsOneWidget);
  });

  // testWidgets("Mapbox base route map", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //       home: Scaffold(
  //     body: Center(
  //         child: Stack(
  //       children: [baseRouteMap.map],
  //     )),
  //   )));
  //   expect(find.byType(MapboxMap), findsOneWidget);
  // });
  testWidgets("Mapbox base station map", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Center(
          child: Stack(
        children: [baseStationMap.map],
      )),
    )));
    expect(find.byType(MapboxMap), findsOneWidget);
  });
}



// await tester.pumpWidget(
    //   // BlocProvider(
    //   //   create: (_) => _cubit,
    //   MaterialApp(
    //     home: MapboxMap(
    //       accessToken: _accessToken,
    //       initialCameraPosition:
    //           CameraPosition(target: LatLng(-50, 1), zoom: 12, tilt: 5),
    //       // onMapCreated: _onMapCreated,
    //       // myLocationEnabled: true,
    //       // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
    //       // annotationOrder: const [AnnotationType.symbol],
    //       // initialCameraPositionCoordinates:
    //       //     _initialCameraPositionCorrdinates,
    //       // initialZoomLevel: _initialZoomLevel,
    //     ),
    //     //   ),
    //   ),
    // );
    // await tester.pump(Duration(seconds: 10));
