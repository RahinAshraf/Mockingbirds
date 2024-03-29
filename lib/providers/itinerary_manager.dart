import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/utilities/enums/travel_type.dart';

class ItineraryManager {
  late Itinerary _itinerary;
  List<Path> _wholeTrip = [];
  late Map _routeResponse;
  final RouteManager _manager = RouteManager();

  ItineraryManager(this._itinerary);

  /// Sets the [journey] and paths
  Future<List<Path>> setJourney() async {
    if (_itinerary.docks!.length > 1) {
      //WALKING:
      _routeResponse = await _manager.getDirections(
          _itinerary.myDestinations![
              0], // takes the first myDestination that the user inputted
          _itinerary.docks![0].getLatlng(), //takes the first dock location
          NavigationType.walking);

      //added: walking latlng to our list:
      _wholeTrip.add(Path.api(
        DockingStation.empty(), // empty because it is the user location
        _itinerary.docks![0], // the first dock in the itinerary
        _itinerary.myDestinations![0],
        _itinerary.myDestinations![0],
        _routeResponse["distance"],
        _routeResponse["duration"],
      ));

      for (int i = 0; i < _itinerary.docks!.length - 1; ++i) {
        //CYCLING:
        var directions = await _manager.getDirections(
            _itinerary.docks![i].getLatlng(),
            _itinerary.docks![i + 1].getLatlng(),
            NavigationType.cycling);

        //added: cycling latlng to our list:
        _wholeTrip.add(Path.api(
            _itinerary.docks![i], //
            _itinerary.docks![i + 1], //
            _itinerary.myDestinations![i],
            _itinerary.myDestinations![i + 1],
            directions["distance"].toDouble(),
            directions["duration"].toDouble()));
      }
    }
    return _wholeTrip;
  }

  Itinerary getItinerary() {
    return _itinerary;
  }

  List<Path> getPaths() {
    return _wholeTrip;
  }
}
