import 'dart:collection';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/helpers/shared_prefs.dart';

import '../providers/route_manager.dart';
import '../utilities/travel_type.dart';

class Trip {
  List<LatLng> _myDestinations;
  List<DockingStation> _docks = [];
  List<Path> _wholeTrip = [];
  int _currentIndex = 0;
  late Map _routeResponse;
  final RouteManager _manager = RouteManager();
  late final List<LatLng> _journey;

  Trip(this._journey, this._docks, this._myDestinations) {
    //createTrip();
    _setJourney(_journey);
  }

  void createTrip() {
    for (var i = 0; i < _docks.length - 1; i++) {
      _wholeTrip.add(Path(_docks[i], _docks[i + 1], _myDestinations[i],
          _myDestinations[i + 1]));
    }
  }

  /// Sets the [journey] geometry
  void _setJourney(List<LatLng> journey) async {
    if (_journey.length > 1) {
      _routeResponse = await _manager.getDirections(
          _journey[0], _journey[1], NavigationType.walking);

      //added: walking latlng to our list:
      _wholeTrip.add(Path.api(DockingStation.empty(), _docks[0], _journey[0],
          _journey[1], _routeResponse["distance"], _routeResponse["duration"]));

      //added: cycling latlng to our list:
      for (int i = 1; i < _journey.length - 1; ++i) {
        var directions = await _manager.getDirections(
            _journey[i], _journey[i + 1], NavigationType.cycling);

        _wholeTrip.add(Path.api(
            _docks[i - 1],
            _docks[i],
            _journey[i],
            _journey[i + 1],
            _routeResponse["distance"],
            _routeResponse["duration"]));
      }
    }
  }

  void updatePath(Path newPath) {
    _wholeTrip[_currentIndex] = newPath;
  }

  void setIndex(int i) {
    _currentIndex = i;
  }

  int getIndex() {
    return _currentIndex;
  }
}
