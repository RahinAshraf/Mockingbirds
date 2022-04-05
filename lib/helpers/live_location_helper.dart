import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:veloplan/alerts.dart';

late SharedPreferences sharedPreferences;

///Author: Rahin Ashraf
class LiveLocationHelper {
  Alerts alert = Alerts();

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
    try {
      LocationData _locationData = await _location.getLocation();
      saveLocation(_locationData);
    } catch (e) {
      //location was denied
    }
  }

  void saveLocation(LocationData _locationData) {
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
  }

}
