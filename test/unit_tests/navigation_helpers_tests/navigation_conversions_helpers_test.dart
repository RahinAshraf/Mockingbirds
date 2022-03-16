import 'package:test/test.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

/// Tests for navigation_conversions_helpers.dart
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723

void main() {

  List<LatLng> prettyCoords = [
    const LatLng(-50, 1),
    const LatLng(-51, -1),
    const LatLng(-50.5, 0)
  ];

  List<LatLng> emptyList = [];

  // group('convert LatLng to waypoint', () {
  //   test('LatLng with empty name should return waypoint with empty name', () {
  //     expect(
  //         latLng2WayPoint(zeroCoord, ""),
  //         WayPoint(
  //             name: "",
  //             latitude: zeroCoord.latitude as double,
  //             longitude: zeroCoord.longitude as double));
  //   });

  //   test('different locations distance should be returned', () {
  //     expect(latLng2WayPoint(prettyCoords[0], "name"),
  //         WayPoint(latitude: 0, longitude: 0, name: ''));
  //     // WayPoint(
  //     //     name: "name",
  //     //     latitude: prettyCoords[0].latitude,
  //     //     longitude: prettyCoords[0].longitude));
  //   });
  // });

  group('test list of lat longs to list of waypoints', () {
    test(
        'List of LatLngs with empty name should return list of waypoints of the same size',
        () {
      var waypoints = latLngs2WayPoints(prettyCoords);
      expect(waypoints.length, prettyCoords.length);
    });

    test(
        'Empty list of LatLngs with empty name should return empty list of waypoints of the same size',
        () {
      var waypoints = latLngs2WayPoints(emptyList);
      expect(waypoints.length, 0);
    });

    // test('List of Latlng returns a waypoint with index as name', () {
    //   var waypoints = latLngs2WayPoints(prettyCoords);
    //   expect(waypoints[0], WayPoint(latitude: -50, longitude: 1, name: '0'));
    //   expect(waypoints[1], WayPoint(latitude: -51, longitude: -1, name: '1'));
    //   expect(waypoints[2], WayPoint(latitude: -50.5, longitude: 0, name: '2'));
    // });
  });

  group('convert LatLng to waypoint', () {
    List<List<double?>?> goodList = [
      [1, 2],
      [3, 4],
      [5, 6]
    ];

    List<List<double?>?> badList = [
      [1, null],
      [3, 4],
      [5, 6]
    ];

    test('empty list should be returned when passing an empty list', () {
      expect(convertListDoubleToLatLng([]), []);
    });

    test('null should be returned when passing a list with null', () {
      expect(convertListDoubleToLatLng(badList), null);
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
  });
}
