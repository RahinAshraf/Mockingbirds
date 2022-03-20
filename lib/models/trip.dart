import 'dart:collection';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/helpers/shared_prefs.dart';

class Trip {
  List<LatLng> _myDestinations;
  List<DockingStation> _docks = [];
  List<Path> _wholeTrip = [];
  int _currentIndex = 0;

  Trip(this._docks, this._myDestinations) {
    createTrip();
  }

  void createTrip() {
    for (var i = 0; i < _docks.length - 1; i++) {
      _wholeTrip.add(Path(_docks[i], _docks[i + 1], _myDestinations[i],
          _myDestinations[i + 1]));
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
