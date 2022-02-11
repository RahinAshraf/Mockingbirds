import 'dart:convert';
import "package:http/http.dart" as http;
import "dart:io";
import '../models/docking_station.dart';
import 'dart:math';

class dockingStationManager {
  List<DockingStation> stations = [];

  Future<void> importStations() async {
    var data = await http.get(Uri.parse("https://api.tfl.gov.uk/BikePoint"));
    int i = 0;
    var jsonData = json.decode(data.body);
    stations.clear();
    for (var station in jsonData) {
      try {
        DockingStation newStation = DockingStation(
            station["id"],
            station["commonName"],
            station["additionalProperties"][1]["value"] == "true",
            station["additionalProperties"][2]["value"] == "true",
            int.parse(station["additionalProperties"][6]["value"]),
            int.parse(station["additionalProperties"][7]["value"]),
            int.parse(station["additionalProperties"][8]["value"]),
            station["lon"],
            station["lat"]);
        if (!newStation.locked) {
          stations.add(newStation);
        }
      } on FormatException {}
    }
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

  List<DockingStation> get_all_stations_with_number_of_bikes(
      int numberOfBikes) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (!station.locked) {
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

  double calculate_distance_btw_2_points(
      DockingStation doc1, DockingStation doc2) {
    return sqrt(pow((doc1.lon - doc2.lon), 2) + pow((doc1.lat - doc2.lat), 2));
  }

  double distance_between_locations(DockingStation doc1, DockingStation doc2) {
    double R = 6371e3;
    double phi1 = (doc1.lat * pi / 180);
    double phi2 = (doc2.lat * pi / 180);

    double phi = (doc1.lat - doc2.lat) * pi / 180;
    double rho = (doc1.lon - doc2.lon) * pi / 180;

    double a = (sin(phi / 2) * sin(phi / 2)) +
        (cos(phi1) * cos(phi2) * sin(rho / 2) * sin(rho / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  List<DockingStation> filter_all_stations_by_distance(
      DockingStation doc, List<DockingStation> stations) {
    stations.sort((a, b) => distance_between_locations(doc, a)
        .compareTo(distance_between_locations(doc, b).toDouble()));
    return stations;
  }
}
