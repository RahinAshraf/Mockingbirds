// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import "dart:io";
import '../models/docking_station.dart';
import 'dart:math';

class dockingStationManager {
  List<DockingStation> stations = [];

/* import the docking stations from the tfl api */
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

  /*  get all open stations */
  List<DockingStation> getAllOpenStations() {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (!station.locked) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  /*get all stations with number of bikes */
  List<DockingStation> getAllStationsWithAvailableBike(int numberOfBikes) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (station.nb_bikes >= numberOfBikes) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  /* get all stations with number empty docks */
  List<DockingStation> getAllStationsWithAvailableSpace(int numberOfDocks) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (station.nb_empty_docks >= numberOfDocks) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  /** 
   * Calculate the distance between two docking stations,
   *  an unprecise formula that doesnt take the curve of Earth 
   * */
  double distanceBtw2Points(DockingStation doc1, DockingStation doc2) {
    return sqrt(pow((doc1.lon - doc2.lon), 2) + pow((doc1.lat - doc2.lat), 2));
  }

  /** Calculate the distance between two docking stations */
  double distanceBtw2Docks(DockingStation doc1, DockingStation doc2) {
    return distanceBtwLocationsHandler(doc1.lon, doc1.lat, doc2.lon, doc2.lat);
  }

  /** 
   * Calculate the distance between given location and docking stations 
   * */
  double distanceBtwLocAndStation(LatLng loc, DockingStation doc) {
    return distanceBtwLocationsHandler(
        loc.longitude, loc.latitude, doc.lon, doc.lat);
  }

  /** 
   * Calculate the distance between two given locations
   * */
  double distanceBtwLocationsHandler(
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

  /** 
   * Return all the 784 stations 
   * */
  List<DockingStation> getStations() {
    return stations;
  }

  /**
   * Filter the given docking stations by distance from the given docking station
  */
  List<DockingStation> filterAllDockingStationsByDistance(DockingStation doc) {
    stations.sort((a, b) => distanceBtw2Docks(doc, a)
        .compareTo(distanceBtw2Docks(doc, b).toDouble()));
    return stations;
  }

  /** 
   * Filter the given docking stations by distance from the given location
   * */
  List<DockingStation> sortDocksByDistanceFromGivenLocation(
      LatLng loc, List<DockingStation> stations) {
    stations.sort((a, b) => distanceBtwLocAndStation(loc, a)
        .compareTo(distanceBtwLocAndStation(loc, b).toDouble()));
    return stations;
  }

  /** 
   *  Get the closest docking station by given docking station and stations
   * */
  DockingStation getClosestDock(LatLng userLocation) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, stations);
    return filteredStations[0];
  }

  /** 
   * Get the 5 closest docking stations by given location and stations
   * */
  List<DockingStation> get5ClosestDocks(LatLng userLocation) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, stations);
    if (filteredStations.isNotEmpty && filteredStations.length > 4) {
      return filteredStations.take(5).toList();
    } else {
      return filteredStations;
    }
  }

  /** 
   *  Get the closest available docking stations by given docking station and stations, minimum of available bikes to get 
   * */
  DockingStation getClosestDockWithAvailableBikes(
      LatLng userLocation, int numberOfBikeSpaces) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(
            userLocation, getAllStationsWithAvailableBike(numberOfBikeSpaces));
    return filteredStations[0];
  }

  /** 
   * Get the closest available docking stations by given docking station and stations, minimum of available bikes to leave 
   * */
  DockingStation getClosestDockWithAvailableSpace(
      LatLng userLocation, int number_of_empty_spaces) {
    List<DockingStation> filtered_stations =
        sortDocksByDistanceFromGivenLocation(userLocation,
            getAllStationsWithAvailableSpace(number_of_empty_spaces));
    return filtered_stations[0];
  }

  /** 
   *  Get the 5 closest available docking stations by given location and stations, number of available bikes to get
   * */
  List<DockingStation> get5ClosestDocksWithAvailableBikes(
      LatLng userLocation, int numberOfBikeSpaces) {
    List<DockingStation> filtered_stations =
        sortDocksByDistanceFromGivenLocation(
            userLocation, getAllStationsWithAvailableBike(numberOfBikeSpaces));
    if (filtered_stations.isNotEmpty && filtered_stations.length > 4) {
      return filtered_stations.take(5).toList();
    } else {
      return filtered_stations;
    }
  }

  /** 
   * Get the 5 closest available docking stations by given location and stations, number of available bikes to leave
  */
  List<DockingStation> get5ClosestDocksWithAvailableSpace(
      LatLng userLocation, int numberOfEmptySpaces) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation,
            getAllStationsWithAvailableSpace(numberOfEmptySpaces));
    if (filteredStations.isNotEmpty && filteredStations.length > 4) {
      return filteredStations.take(5).toList();
    } else {
      return filteredStations;
    }
  }
}
