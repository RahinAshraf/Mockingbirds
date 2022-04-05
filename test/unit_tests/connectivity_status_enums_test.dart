import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/utilities/connectivity_status_enums.dart';

void main() async {
  /// Returns [true] if [enumeratedValue] is an Enumerated Type
  bool isEnum(dynamic enumeratedValue) {
    final splitEnum = enumeratedValue.toString().split('.');
    return splitEnum.length > 1 &&
        splitEnum[0] == enumeratedValue.runtimeType.toString();
  }

  /// Retrieves [String] for enumaerated type
  String enumToString(dynamic enumeratedValue) {
    final splitEnum = enumeratedValue.toString().split('.');
    return splitEnum[1];
  }

  group('test if enumerated types for internet connection', () {
    test('connection status type wifi returns String walking', () async {
      expect((isEnum(ConnectivityStatus.Wifi)), true);
    });
    test('connection status type wifi returns String walking', () async {
      expect((isEnum(ConnectivityStatus.Mobile)), true);
    });
    test('connection status type wifi returns String walking', () async {
      expect((isEnum(ConnectivityStatus.Offline)), true);
    });
  });
  group('test the string result of enumerated types for internet connection',
      () {
    test('connection status type wifi returns String walking', () async {
      expect((enumToString(ConnectivityStatus.Wifi)), "Wifi");
    });
    test('connection status type wifi returns String walking', () async {
      expect((enumToString(ConnectivityStatus.Mobile)), "Mobile");
    });
    test('connection status type wifi returns String walking', () async {
      expect((enumToString(ConnectivityStatus.Offline)), "Offline");
    });
  });
}
