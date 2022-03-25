import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/models/path.dart';

import '../providers/route_manager.dart';
import '../utilities/travel_type.dart';

class ItineraryManager {
  late Itinerary _itinerary;
  List<Path> _wholeTrip = [];
  int _currentIndex = 0;
  late Map _routeResponse;
  final RouteManager _manager = RouteManager();

  ItineraryManager(this._itinerary) {
    _setJourney();
    print("helooooo i am in itinerary manager class -------");
  }

  /// Sets the [journey] and paths
  void _setJourney() async {
    if (_itinerary.docks!.length > 1) {
      //WALKING:
      _routeResponse = await _manager.getDirections(
          _itinerary.docks![0].getLatlng(),
          _itinerary.docks![1].getLatlng(),
          NavigationType.walking);

      //added: walking latlng to our list:
      _wholeTrip.add(Path.api(
        DockingStation.empty(),
        DockingStation.empty(), //_docks[0],
        _itinerary.docks![0].getLatlng(),
        _itinerary.docks![1].getLatlng(),
        _routeResponse["distance"],
        _routeResponse["duration"],
      ));

      for (int i = 1; i < _itinerary.docks!.length - 1; ++i) {
        //CYCLING:
        var directions = await _manager.getDirections(
            _itinerary.docks![i].getLatlng(),
            _itinerary.docks![i + 1].getLatlng(),
            NavigationType.cycling);

        //added: cycling latlng to our list:
        _wholeTrip.add(Path.api(
            DockingStation.empty(), //_docks[i - 1],
            DockingStation.empty(), // _docks[i],
            _itinerary.docks![i].getLatlng(),
            _itinerary.docks![i + 1].getLatlng(),
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
