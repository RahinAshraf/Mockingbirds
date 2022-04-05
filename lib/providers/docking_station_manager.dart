import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:math';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/models/docking_station.dart';

/// The handler of docking stations which makes api calls, updates data,
/// sorts docking stations and filters them in different ways.
/// Authors: Nicole, Lilianna
class dockingStationManager {
  List<DockingStation> stations = [];

  /// import the docking stations from the tfl api, imports all 788 docking stations
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

        if (!newStation.isLocked) {
          stations.add(newStation);
        }
      } on FormatException {}
    }
  }

  ///  get all open stations
  List<DockingStation> getAllOpenStations() {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (!station.isLocked) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  /// get all stations with number of bikes
  List<DockingStation> getAllStationsWithAvailableBike(int numberOfBikes) {
    List<DockingStation> openStations = [];
    for (var station in stations) {
      if (station.numberOfBikes >= numberOfBikes) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  /// get all stations with number empty docks
  List<DockingStation> getAllStationsWithAvailableSpace(int numberOfDocks) {
    return getAllStationsWithAvailableSpaceHandler(
        numberOfDocks, this.stations);
  }

  /// get all stations with number empty docks
  List<DockingStation> getAllStationsWithAvailableSpaceHandler(
      int numberOfDocks, List<DockingStation> inputStations) {
    List<DockingStation> openStations = [];
    for (var station in inputStations) {
      if (station.numberOfEmptyDocks >= numberOfDocks) {
        openStations.add(station);
      }
    }
    return openStations;
  }

  ///  Calculate the distance between two docking stations,
  ///  an unprecise formula that doesnt take the curve of Earth
  double distanceBtw2Points(DockingStation doc1, DockingStation doc2) {
    return sqrt(pow((doc1.lon - doc2.lon), 2) + pow((doc1.lat - doc2.lat), 2));
  }

  /// Calculate the distance between two docking stations
  double distanceBtw2Docks(DockingStation doc1, DockingStation doc2) {
    return distanceBtwLocationsHandler(doc1.lon, doc1.lat, doc2.lon, doc2.lat);
  }

  /// Calculate the distance between given location and docking stations
  double distanceBtwLocAndStation(LatLong.LatLng loc, DockingStation doc) {
    return distanceBtwLocationsHandler(
        loc.longitude, loc.latitude, doc.lon, doc.lat);
  }

  /// Calculate the distance between two given locations
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

  /// Return all the 790 stations, may change depending on api
  List<DockingStation> getStations() {
    return stations;
  }

  /// Filter the given docking stations by distance from the given docking station
  List<DockingStation> filterAllDockingStationsByDistance(DockingStation doc) {
    stations.sort((a, b) => distanceBtw2Docks(doc, a)
        .compareTo(distanceBtw2Docks(doc, b).toDouble()));
    return stations;
  }

  ///Filter the given docking stations by distance from the given location
  List<DockingStation> sortDocksByDistanceFromGivenLocation(
      LatLong.LatLng loc, List<DockingStation> stations) {
    stations.sort((a, b) => distanceBtwLocAndStation(loc, a)
        .compareTo(distanceBtwLocAndStation(loc, b).toDouble()));
    return stations;
  }

  ///  Get the closest docking station by given docking station and stations
  DockingStation getClosestDock(LatLong.LatLng userLocation) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, stations);
    return filteredStations[0];
  }

  /// Get the 5 closest docking stations by given location and stations
  List<DockingStation> get5ClosestDocks(LatLong.LatLng userLocation) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, stations);
    if (filteredStations.isNotEmpty && filteredStations.length > 4) {
      return filteredStations.take(5).toList();
    } else {
      return filteredStations;
    }
  }

  /// Get the 10 closest docking stations by given location and stations
  List<DockingStation> get10ClosestDocks(LatLong.LatLng userLocation) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, stations);
    if (filteredStations.isNotEmpty && filteredStations.length > 9) {
      return filteredStations.take(10).toList();
    } else {
      return filteredStations;
    }
  }

  ///  Get the closest available docking stations by given docking station and stations, minimum of available bikes to get
  DockingStation getClosestDockWithAvailableBikes(
      LatLong.LatLng userLocation, int numberOfBikeSpaces) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(
            userLocation, getAllStationsWithAvailableBike(numberOfBikeSpaces));
    return filteredStations[0];
  }

  /// Get the closest available docking stations by given docking station and stations, minimum of available bikes to leave
  DockingStation getClosestDockWithAvailableSpace(
      LatLong.LatLng userLocation, int number_of_empty_spaces) {
    return getClosestDockWithAvailableSpaceHandler(
        userLocation, number_of_empty_spaces, this.stations);
  }

  /// Get the closest available docking stations by given docking station and stations, minimum of available bikes to leave
  DockingStation getClosestDockWithAvailableSpaceHandler(
      LatLong.LatLng userLocation,
      int number_of_empty_spaces,
      List<DockingStation> inputStations) {
    List<DockingStation> filtered_stations =
        sortDocksByDistanceFromGivenLocation(
            userLocation,
            getAllStationsWithAvailableSpaceHandler(
                number_of_empty_spaces, inputStations));
    if (filtered_stations[0] != null)
      return filtered_stations[0];
    else {
      //! TODO:turn to null or write a handler
      print(
          "----------------------------it was called on an empty docking station-------------------------------");
      return DockingStation.empty();
    }
  }

  ///  Get the 5 closest available docking stations by given location and stations, number of available bikes to get
  List<DockingStation> get5ClosestDocksWithAvailableBikes(
      LatLong.LatLng userLocation, int numberOfBikeSpaces) {
    List<DockingStation> filtered_stations =
        sortDocksByDistanceFromGivenLocation(
            userLocation, getAllStationsWithAvailableBike(numberOfBikeSpaces));
    if (filtered_stations.isNotEmpty && filtered_stations.length > 4) {
      return filtered_stations.take(5).toList();
    } else {
      return filtered_stations;
    }
  }

  /// Get the 5 closest available docking stations by given location and stations, number of available bikes to leave
  List<DockingStation> get5ClosestDocksWithAvailableSpace(
      LatLong.LatLng userLocation, int numberOfEmptySpaces) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation,
            getAllStationsWithAvailableSpace(numberOfEmptySpaces));
    if (filteredStations.isNotEmpty && filteredStations.length > 4) {
      return filteredStations.take(5).toList();
    } else {
      return filteredStations;
    }
  }

  /// Method useful for testing
  void removeStations(int range) {
    stations.removeRange(range, stations.length);
  }

  ///  Get the 10 closest available docking stations by given location and stations, number of available bikes to get
  List<DockingStation> get10ClosestDocksWithAvailableBikes(
      LatLong.LatLng userLocation, int numberOfBikeSpaces) {
    List<DockingStation> filtered_stations =
        sortDocksByDistanceFromGivenLocation(
            userLocation, getAllStationsWithAvailableBike(numberOfBikeSpaces));
    if (filtered_stations.isNotEmpty && filtered_stations.length > 9) {
      return filtered_stations.take(10).toList();
    } else {
      return filtered_stations;
    }
  }

  /// Get the 10 closest available docking stations by given location and stations, number of available bikes to leave
  List<DockingStation> get10ClosestDocksWithAvailableSpace(
      LatLong.LatLng userLocation, int numberOfEmptySpaces) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation,
            getAllStationsWithAvailableSpace(numberOfEmptySpaces));
    if (filteredStations.isNotEmpty && filteredStations.length > 9) {
      return filteredStations.take(10).toList();
    } else {
      return filteredStations;
    }
  }

  /// Import a docking station from the tfl api, update its info
  Future<DockingStation> checkStation(DockingStation dock) async {
    /// make the api call to tfl
    var data = await http
        .get(Uri.parse("https://api.tfl.gov.uk/BikePoint/${dock.stationId}"));
    while (data == null) {
      await Future.delayed(const Duration(seconds: 20));
      data = await http
          .get(Uri.parse("https://api.tfl.gov.uk/BikePoint/${dock.stationId}"));
    }
    var station = json.decode(data.body);
    try {
      dock.setNumberOfBikes =
          int.parse(station["additionalProperties"][6]["value"]);
      dock.setNumberOfEmptyDocks =
          int.parse(station["additionalProperties"][7]["value"]);
      dock.setNumberOfAllDocks =
          int.parse(station["additionalProperties"][8]["value"]);
      dock.setIsInstalled = true;
      dock.setisLocked = station["additionalProperties"][2]["value"] == "true";
    } on FormatException {}
    return dock;
  }

  /* import the docking station from the tfl api and check its updated info*/
  //TODO: refactor code -> shitty code
  Future<DockingStation?> checkStationById(String dockId) async {
    // print("------------dock id in check statin by id" + dockId.toString());

    /// make the api call to tfl
    var data =
        await http.get(Uri.parse("https://api.tfl.gov.uk/BikePoint/${dockId}"));

    /// make the api calls until it doesnt return null
    while (data == null) {
      await Future.delayed(const Duration(seconds: 20));
      data = await http
          .get(Uri.parse("https://api.tfl.gov.uk/BikePoint/${dockId}"));
    }
    print("-----------------check station by id---------" +
        (data == null).toString());
    late DockingStation newStation;
    var station = json.decode(data.body);
    try {
      print("station id------" + station["id"]);
      newStation = DockingStation(
          station["id"],
          station["commonName"],
          station["additionalProperties"][1]["value"] == "true",
          station["additionalProperties"][2]["value"] == "true",
          int.parse(station["additionalProperties"][6]["value"]),
          int.parse(station["additionalProperties"][7]["value"]),
          int.parse(station["additionalProperties"][8]["value"]),
          station["lon"],
          station["lat"]);
      // print(newStation.stationId +
      //     "      " +
      //     newStation.name +
      //     "-----------------__________-debug stations__________--------");
    } on FormatException {}

    /// return an empty dock if there is no data from the api call
    if (newStation != null) {
      return newStation;
    } else {
      print("Returning an empty dock from checkStationById ");
      DockingStation.empty();
    }
  }

  /// Update the docking station info and check for available spaces
  Future<bool> checkDockWithAvailableSpace(
      DockingStation dock, int numberOfBikes) async {
    dock.assign(await checkStation(dock));
    return (dock.numberOfEmptyDocks >= numberOfBikes);
  }

  /// Update the docking station info and check for available bikes
  Future<bool> checkDockWithAvailableBikes(
      DockingStation dock, int numberOfBikes) async {
    dock.assign(await checkStation(dock));
    return (dock.numberOfBikes >= numberOfBikes);
  }

  /// Get the 10 closest docking stations by given location and stations
  List<DockingStation> get10ClosestDocksFav(
      LatLong.LatLng userLocation, List<DockingStation> favDocks) {
    List<DockingStation> filteredStations =
        sortDocksByDistanceFromGivenLocation(userLocation, favDocks);
    if (filteredStations.isNotEmpty && filteredStations.length > 9) {
      return filteredStations.take(10).toList();
    } else {
      return filteredStations;
    }
  }

  /// import the docking stations from the tfl api by a set radius and coordinates
  Future<List<DockingStation>> importStationsByRadius(
      int radius, LatLng coord) async {
    /// make the api call to tfl
    var data = await http.get(Uri.parse(
        "https://api.tfl.gov.uk/Place?lat=${coord.latitude}&lon=${coord.longitude}&radius=${radius}&type=BikePoint"));

    /// make the api calls until it doesnt return null
    while (data == null) {
      await Future.delayed(const Duration(seconds: 20));
      data = await http.get(Uri.parse(
          "https://api.tfl.gov.uk/Place?lat=${coord.latitude}&lon=${coord.longitude}&radius=${radius}&type=BikePoint"));
    }

    List<DockingStation> newStations = [];
    var stations = json.decode(data.body);
    for (var station in stations) {
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

        if (!newStation.isLocked) {
          newStations.add(newStation);
        }
      } on FormatException {}
    }
    if (newStations.length > 0) {
      return newStations;
    } else {
      print("Returning an empty list from importStationsByRadius ");
      return newStations;
    }
  }
}
