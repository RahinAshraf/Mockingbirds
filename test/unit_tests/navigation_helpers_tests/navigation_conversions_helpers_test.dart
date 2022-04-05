import 'package:flutter_mapbox_navigation/library.dart';
import 'package:test/test.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../docking_station_tests/docking_stations_values.dart';

/// Tests for navigation_conversions_helpers.dart
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723

void main() {
  List<LatLng> prettyCoords = [
    const LatLng(-50, 1),
    const LatLng(-51, -1),
    const LatLng(-50.5, 0)
  ];

  List<LatLng> emptyList = [];

  LatLng zeroCoord = LatLng(0, 0);

  dockingStationManager stationManager2Docks = dockingStationManager();
  List<DockingStation> dockingStationsList = get2DummyDocks().stations;

  group('convert LatLng to waypoint', () {
    test('LatLng with empty name should return waypoint with empty name', () {
      String name = "";
      WayPoint wayPoint = latLng2WayPoint(zeroCoord, name);
      expect(wayPoint.name, name);
      expect(wayPoint.latitude, zeroCoord.latitude);
      expect(wayPoint.longitude, zeroCoord.longitude);
    });

    test('different locations distance should be returned', () {
      String name = "name";
      LatLng coord = prettyCoords[0];
      WayPoint wayPoint = latLng2WayPoint(coord, name);
      expect(wayPoint.name, name);
      expect(wayPoint.latitude, coord.latitude);
      expect(wayPoint.longitude, coord.longitude);
    });
  });

  group('test list of lat longs to list of waypoints', () {
    test("List of LatLngs with empty name should return list valid wayponints",
        () {
      var waypoints = latLngs2WayPoints(prettyCoords);
      expect(waypoints.length, prettyCoords.length);
      for (int i = 0; i < waypoints.length; ++i) {
        waypoints[i].latitude = prettyCoords[i].latitude;
        waypoints[i].longitude = prettyCoords[i].longitude;
        waypoints[i].name = i.toString();
      }
    });

    test(
        'Empty list of LatLngs with empty name should return empty list of waypoints of the same size',
        () {
      var waypoints = latLngs2WayPoints(emptyList);
      expect(waypoints.length, 0);
    });

    test('List of Latlng returns a waypoint with index as name', () {
      var waypoints = latLngs2WayPoints(prettyCoords);
      for (int i = 0; i < waypoints.length; ++i) {
        waypoints[i].name = i.toString();
      }
    });
  });

  group('convert LatLng to waypoint', () {
    List<List<double?>?> goodList = [
      [1, 2],
      [3, 4],
      [5, 6]
    ];

    List<List<double?>?> listWithNull = [
      [1, null],
      [3, 4],
      [5, 6]
    ];

    List<List<double?>?> toSmallList = [
      [1],
      [3],
      [5]
    ];

    List<List<double?>?> toBigList = [
      [1, 2, 3],
      [3, 4],
      [5, 6]
    ];

    test('empty list should be returned when passing an empty list', () {
      expect(convertListDoubleToLatLng([]), []);
    });

    test('null should be returned when passing a list with null', () {
      expect(convertListDoubleToLatLng(listWithNull), null);
    });

    test('LatLng points should be assigned in a good list', () {
      List<LatLng>? list = convertListDoubleToLatLng(goodList);
      int length = list?.length as int;
      expect(goodList.length, length);
      for (int i = 0; i < length; ++i) {
        LatLng currentPoint = list![i];
        expect(currentPoint.latitude, goodList[i]![0]);
        expect(currentPoint.longitude, goodList[i]![1]);
      }
    });

    test('too big or small list should return null', () {
      List<LatLng>? toSmall = convertListDoubleToLatLng(toSmallList);
      List<LatLng>? toBig = convertListDoubleToLatLng(toBigList);
      expect(toSmall, null);
      expect(toBig, null);
    });

    test('too big list should return null', () {
      List<LatLng>? list = convertListDoubleToLatLng(goodList);
      int length = list?.length as int;
      expect(goodList.length, length);
      for (int i = 0; i < length; ++i) {
        LatLng currentPoint = list![i];
        expect(currentPoint.latitude, goodList[i]![0]);
        expect(currentPoint.longitude, goodList[i]![1]);
      }
    });
  });

  group('test list of lat longs to list of list of doubles', () {
    test("List of LatLngs is converted to list of doubles", () {
      var doubles = convertLatLngToDouble(prettyCoords);
      expect(doubles?.length, prettyCoords.length);
      for (int i = 0; i < doubles!.length; ++i) {
        expect(doubles[i]![0], prettyCoords[i].latitude);
        expect(doubles[i]![1], prettyCoords[i].longitude);
      }
    });

    test(
        'Empty list of LatLngs with should return empty list of list of doubles of the same size',
        () {
      var doubles = convertLatLngToDouble(emptyList);
      expect(doubles!.length, 0);
    });
  });

  group('test list of docking station to list of list of doubles', () {
    test("List of Docking stations is converted to list of doubles", () {
      var doubles = convertDocksToDouble(dockingStationsList);
      expect(doubles!.length, dockingStationsList.length);

      for (int i = 0; i < doubles.length; ++i) {
        expect(doubles[i]![0], dockingStationsList[i].lat);
      }
    });

    test(
        'Empty list of LatLngs with should return empty list of list of doubles of the same size',
        () {
      List<DockingStation> emptyDockingStationsList = [];
      var doubles = convertDocksToDouble(emptyDockingStationsList);
      expect(doubles!.length, 0);
    });
  });
}
