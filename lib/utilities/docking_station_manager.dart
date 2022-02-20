
import 'package:veloplan/providers/docking_station_fetcher.dart';

import '../models/docking_station.dart';

class dockingStationManager{
  List<DockingStation> stations = [];

  dockingStationManager(){
     final dockingStationFetcher stationFetcher = dockingStationFetcher();
    stationFetcher
        .importStations()
        .then((value) => stations = stationFetcher.stations);
  }

  List<DockingStation> get_all_open_stations() {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (!station.locked) {
        openStations.add(station);
      }
    }
    return openStations;
  }


  List<DockingStation> get_all_stations_with_number_of_bikes(int numberOfBikes) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (station.nb_bikes >= numberOfBikes) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  List<DockingStation> get_all_stations_with_number_empty_docks(
      int numberOfDocks) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (station.nb_empty_docks >= numberOfDocks) {
        openStations.add(station);
      }
    }
    return openStations;
  }
}
