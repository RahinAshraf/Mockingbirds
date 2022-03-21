import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/path.dart';

import '../providers/route_manager.dart';
import '../utilities/travel_type.dart';

class Trip {
  List<LatLng> _myDestinations = [];
  List<DockingStation> _docks = [];
  List<Path> _wholeTrip = [];
  int _currentIndex = 0;
  late Map _routeResponse;
  final RouteManager _manager = RouteManager();
  late List<LatLng> _journey;

  Trip(this._journey) {
    _setJourney();
    print("helooooo i am in trip class -------");
  }

  /// Sets the [journey] and paths
  void _setJourney() async {
    if (_journey.length > 1) {
      //WALKING:
      _routeResponse = await _manager.getDirections(
          _journey[0], _journey[1], NavigationType.walking);

      //added: walking latlng to our list:
      _wholeTrip.add(Path.api(
        DockingStation.empty(),
        DockingStation.empty(), //_docks[0],
        _journey[0],
        _journey[1],
        _routeResponse["distance"],
        _routeResponse["duration"],
      ));

      for (int i = 1; i < _journey.length - 1; ++i) {
        //CYCLING:
        var directions = await _manager.getDirections(
            _journey[i], _journey[i + 1], NavigationType.cycling);

        //added: cycling latlng to our list:
        _wholeTrip.add(Path.api(
            DockingStation.empty(), //_docks[i - 1],
            DockingStation.empty(), // _docks[i],
            _journey[i],
            _journey[i + 1],
            directions["distance"].toDouble(),
            directions["duration"].toDouble()));
      }
    }
    //uncomment if you want to test it!
    //printPaths();
  }

  List<Path> getPaths() {
    return _wholeTrip;
  }

  void printPaths() {
    for (var path in _wholeTrip) {
      path.printPath();
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
