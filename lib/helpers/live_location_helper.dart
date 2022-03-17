import 'package:permission_handler/permission_handler.dart'
    as Permission_handler;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

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
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
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
  var locationStatus = await Permission_handler.Permission.location.status;

  if (locationStatus.isGranted) {
    print("GRANTED");
  } else if (locationStatus.isDenied) {
    await Permission_handler.Permission.location.request();
    print("- WAS DENIED - NOW REQUESTED");
  } else if (locationStatus.isPermanentlyDenied) {
    print("TELL USERS TO GO TO SETTINGS TO ALLOW LOCATION");
  } else if (locationStatus.isLimited) {
    print("ISLIMITED WAS SELECTED");
  }
}
//}
