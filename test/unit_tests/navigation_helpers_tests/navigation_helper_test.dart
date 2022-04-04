import 'package:test/test.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';

/// Tests for navigation_helpers.dart
/// Author(s): Elisabeth Koren Halvorsen k20077737, Fariha Choudhury k20059723

void main() {
  List<LatLng> points = [
    const LatLng(51.514951, -0.112762),
    const LatLng(51.513146, -0.115256),
    const LatLng(51.511407, -0.125497),
    const LatLng(51.506053, -0.130310),
    const LatLng(51.502254, -0.217760),
  ];
  List<LatLng> empty = [
    const LatLng(0, 0),
    const LatLng(0, 0),
  ];
  List<LatLng> prettyCoords = [
    const LatLng(-50, 1),
    const LatLng(-51, -1),
    const LatLng(-50.5, 0)
  ];

  const LatLng zeroCoord = LatLng(0, 0);

  group('calculate distance', () {
    test('same location zero should be returned', () {
      expect(calculateDistance(zeroCoord, zeroCoord), 0);
    });

    test('different locations distance should be returned', () {
      expect(
          calculateDistance(const LatLng(40.689202777778, -74.044219444444),
              const LatLng(38.889069444444, -77.034502777778)),
          324.53489135923684);
    });
  });

  group('calculate midpoint', () {
    test('same location zero should be returned', () {
      expect(getMidpoint(zeroCoord, zeroCoord), zeroCoord);
    });

    test('different locations distance should be returned', () {
      expect(getMidpoint(zeroCoord, zeroCoord), const LatLng(0, 0));
    });
  });

  group('calculate center from points', () {
    test('same location zero should be returned', () {
      expect(getCenter(empty), zeroCoord);
    });

    test('different locations center should be returned', () {
      expect(getCenter(points), const LatLng(51.502254, -0.16526099999998678));
    });
  });

  group('calculate zoom from points', () {
    test('invalid numbe should return -1', () {
      expect(getZoom(0), -1);
    });

    test('big number should returns 0', () {
      expect(getZoom(10000000), 0);
    });

    test('small number should returns 20', () {
      expect(getZoom(0.001), 20);
    });
  });

  group('calculate corner coordinates from points', () {
    test('same location zero should be returned', () {
      expect(getCornerCoordinates(empty), const Tuple2(zeroCoord, zeroCoord));
    });

    test('different locations corner coordinates should be returned', () {
      expect(getCornerCoordinates(prettyCoords),
          const Tuple2(LatLng(-51.0, 1.0), LatLng(-50.0, -1.0)));
    });

    test('one location corner coordinates should be returned', () {
      expect(getCornerCoordinates([zeroCoord]),
          const Tuple2(zeroCoord, zeroCoord));
    });
  });
}
