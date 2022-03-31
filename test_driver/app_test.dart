import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart';

void main() {
  group('first', () {
    FlutterDriver? driver;
    final emailField = find.byValueKey("email");
    final passwordField = find.byValueKey("password");
    final loginButton = find.byValueKey('logIn');
    final snackbar = find.byType("SnackBar");
    final navBarPage = find.byType("NavBar");
// connect flutter driver to the app before executing the runs
    setUpAll(() async {
      print("----------" + Platform.environment.toString());
      final envVars = Platform.environment;
      print("----------" + envVars['ANDROID_SDK_ROOT'].toString());
      final adbPath = join(
        envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME']!,
        'platform-tools',
        Platform.isWindows ? 'adb.exe' : 'adb',
      );
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'com.example.yourapp', // replace with your app id
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      driver = await FlutterDriver.connect();

      // final Map<String, String> envVars = Platform.environment;
      // final String adbPath =
      //     envVars['ANDROID_SDK_ROOT']! + '/platform-tools/adb.exe';
      // await Process.run(adbPath, [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.READ_EXTERNAL_STORAGE'
      // ]);
      // await Process.run(adbPath, [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.READ_PHONE_STATE'
      // ]);
      // await Process.run(adbPath, [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.ACCESS_FINE_LOCATION'
      // ]);
      // driver = await FlutterDriver.connect();
      // driver = await FlutterDriver.connect(timeout: Duration(seconds: 5));
      // await Process.run('add_adb_path/adb.exe', [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.ACCESS_MEDIA_LOCATION'
      // ]);
      // await Process.run('add_adb_path/adb.exe', [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.ACCESS_COARSE_LOCATION'
      // ]);
      // await Process.run('add_adb_path/adb.exe', [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.ACCESS_BACKGROUND_LOCATION'
      // ]);
      // await Process.run('add_adb_path/adb.exe', [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.READ_EXTERNAL_STORAGE'
      // ]);
      // await Process.run('add_adb_path/adb.exe', [
      //   'shell',
      //   'pm',
      //   'grant',
      //   'com.example.veloplan',
      //   'android.permission.WRITE_EXTERNAL_STORAGE'
      // ]);
    });
// disconnect flutter driver from the app after executing the runs
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });

    test("login failed", () async {
      await driver?.tap(emailField);
      await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
//       await driver?.enterText("elisabeth.koren.halvorsen@gmail.com");
      await driver?.tap(passwordField);
      await driver?.enterText("Password123");
      // await Future.delayed(Duration(seconds: 3));
      await driver?.tap(loginButton);
      // await driver?.waitFor(snackbar);
      // assert(snackbar != null);
      assert(snackbar == null);
      await driver?.waitUntilNoTransientCallbacks();
      assert(navBarPage != null);
    });
  });
}
