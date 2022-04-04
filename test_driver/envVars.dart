import 'dart:io';
import 'package:path/path.dart';

///addpermission for locations so that we dont press every time allow to use location
Future<void> setUpEnvVars() async {
  final envVars = Platform.environment;
  final adbPath = join(
    envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME']!,
    'platform-tools',
    Platform.isWindows ? 'adb.exe' : 'adb',
  );

  /// accept location permissions
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.yourapp', // replace with your app id
    'android.permission.ACCESS_FINE_LOCATION'
  ]);

  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.ACCESS_COARSE_LOCATION'
  ]);
  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.ACCESS_BACKGROUND_LOCATION'
  ]);

  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.READ_EXTERNAL_STORAGE'
  ]);

  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.READ_PHONE_STATE'
  ]);

  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.ACCESS_MEDIA_LOCATION'
  ]);

  await Process.run(adbPath, [
    'shell',
    'pm',
    'grant',
    'com.example.veloplan',
    'android.permission.WRITE_EXTERNAL_STORAGE'
  ]);
}
