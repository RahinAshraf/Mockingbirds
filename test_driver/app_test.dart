import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('first', () {
    FlutterDriver? driver;
// connect flutter driver to the app before executing the runs
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
// disconnect flutter driver from the app after executing the runs
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });
  });
}
