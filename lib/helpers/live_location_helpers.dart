import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

late SharedPreferences sharedPreferences;

//class LiveLocationHelper {
void initializeLocation() async {
  sharedPreferences = await SharedPreferences.getInstance();
  bool? _serviceEnabled;
  Location _location = Location();
  PermissionStatus? _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) {
      print(
          "not enabled not enabled not enabled ------------------------------------");
    }
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      print(
          "not granted not granted not granted ------------------------------------");
    }
  }

  // do{
  //   await _location.requestPermission();
  // }
  // while(_permissionGranted != PermissionStatus.granted);

  LocationData _locationData = await _location.getLocation();
  LatLng currentLatLng =
      LatLng(_locationData.latitude!, _locationData.longitude!);

  saveLocation(_locationData);
}

void saveLocation(LocationData _locationData) {
  sharedPreferences.setDouble('latitude', _locationData.latitude!);
  sharedPreferences.setDouble('longitude', _locationData.longitude!);
}

void checkPermissions() async {
  var locationStatus = await permission_handler.Permission.location.status;

  if (locationStatus.isGranted) {
    print("GRANTED");
  } else if (locationStatus.isDenied) {
    await permission_handler.Permission.location.request();
    print("ISDENIED HAPPENED");
  } else if (locationStatus.isPermanentlyDenied) {
    print("TELL USERS TO GO TO SETTINGS TO ALLOW LOCATION");
  } else if (locationStatus.isLimited) {
    print("ISLIMITED WAS SELECTED");
  }
}
//}
