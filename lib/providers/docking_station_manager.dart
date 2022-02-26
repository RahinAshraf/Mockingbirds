import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import "dart:io";
import '../models/docking_station.dart';
import 'dart:math';

class dockingStationManager {
  List<DockingStation> stations = [];

  Future<void> importStations() async {
    var data = await http.get(Uri.parse("https://api.tfl.gov.uk/BikePoint"));
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

  /** Calculate the distance between two docking stations,
   *  an unprecise formula that doesnt take the curve of Earth */
  double distance_btw_2_points(DockingStation doc1, DockingStation doc2) {
    return sqrt(pow((doc1.lon - doc2.lon), 2) + pow((doc1.lat - doc2.lat), 2));
  }

  /** Calculate the distance between two docking stations */
  double distance_btw_2_stations(DockingStation doc1, DockingStation doc2) {
    return distance_btw_locations_handler(
        doc1.lon, doc1.lat, doc2.lon, doc2.lat);
  }

  /** Calculate the distance between given location and docking stations */
  double distance_btw_loc_and_station(LatLng loc, DockingStation doc) {
    return distance_btw_locations_handler(
        loc.longitude, loc.latitude, doc.lon, doc.lat);
  }

  /** Calculate the distance between two given locations*/
  double distance_btw_locations_handler(
      double lon1, double lat1, double lon2, double lat2) {
    double R = 6371e3;
    double phi1 = (lat1 * pi / 180);
    double phi2 = (lat2 * pi / 180);

    double phi = (lat1 - lat2) * pi / 180;
    double rho = (lon1 - lon2) * pi / 180;

    double a = (sin(phi / 2) * sin(phi / 2)) +
        (cos(phi1) * cos(phi2) * sin(rho / 2) * sin(rho / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  /** Return all the 784 stations */
  List<DockingStation> getStations() {
    return stations;
  }

  /* Filter the given docking stations by distance from the given docking station*/
  List<DockingStation> filterAllDockingStationsByDistance(DockingStation doc) {
    stations.sort((a, b) => distance_btw_2_stations(doc, a)
        .compareTo(distance_btw_2_stations(doc, b).toDouble()));
    return stations;
  }

  /* Filter the given docking stations by distance from the given location*/
  List<DockingStation> sort_docs_by_distance_from_loc(
      LatLng loc, List<DockingStation> stations) {
    stations.sort((a, b) => distance_btw_loc_and_station(loc, a)
        .compareTo(distance_btw_loc_and_station(loc, b).toDouble()));
    return stations;
  }

  /* Get the closest docking station by given docking station and stations*/
  DockingStation get_closest_dock(LatLng user_location) {
    List<DockingStation> filtered_stations =
        sort_docs_by_distance_from_loc(user_location, stations);
    return filtered_stations[0];
  }

  /* Get the 5 closest docking stations by given location and stations*/
  List<DockingStation> get_5_closest_docks(LatLng user_locationd) {
    List<DockingStation> filtered_stations =
        sort_docs_by_distance_from_loc(user_locationd, stations);
    if (filtered_stations.isNotEmpty && filtered_stations.length > 4) {
      return filtered_stations.take(5).toList();
    } else {
      return filtered_stations;
    }
  }

  /* Get the closest available docking stations by given docking station and stations, minimum of available bikes to get */
  DockingStation get_closest_dock_to_get_bikes(
      LatLng user_location, int number_of_bike_spaces) {
    List<DockingStation> filtered_stations = sort_docs_by_distance_from_loc(
        user_location,
        get_all_stations_with_number_of_bikes(number_of_bike_spaces));
    return filtered_stations[0];
  }

  /* Get the closest available docking stations by given docking station and stations, minimum of available bikes to leave */
  DockingStation get_closest_dock_to_leave_bikes(
      LatLng user_location, int number_of_empty_spaces) {
    List<DockingStation> filtered_stations = sort_docs_by_distance_from_loc(
        user_location,
        get_all_stations_with_number_empty_docks(number_of_empty_spaces));
    return filtered_stations[0];
  }

  /* Get the 5 closest available docking stations by given location and stations, number of available bikes to get*/
  List<DockingStation> get_5_closest_docks_to_get_bikes(
      LatLng user_location, int number_of_bike_spaces) {
    List<DockingStation> filtered_stations = sort_docs_by_distance_from_loc(
        user_location,
        get_all_stations_with_number_of_bikes(number_of_bike_spaces));
    if (filtered_stations.isNotEmpty && filtered_stations.length > 4) {
      return filtered_stations.take(5).toList();
    } else {
      return filtered_stations;
    }
  }

  /* Get the 5 closest available docking stations by given location and stations, number of available bikes to leave*/
  List<DockingStation> get_5_closest_docks_to_leave_bikes(
      LatLng user_location, int number_of_empty_spaces) {
    List<DockingStation> filtered_stations = sort_docs_by_distance_from_loc(
        user_location,
        get_all_stations_with_number_empty_docks(number_of_empty_spaces));
    if (filtered_stations.isNotEmpty && filtered_stations.length > 4) {
      return filtered_stations.take(5).toList();
    } else {
      return filtered_stations;
    }
  }
}
