import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import "package:http/http.dart" as http;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/helpers/shared_prefs.dart';

import '../models/docking_station.dart';
import '../models/path.dart';

class PathProvider {
  String matrixUrl = 'https://api.mapbox.com/directions-matrix/v1/mapbox';
  final String routingProfile = 'cycling';
  final String YOUR_MAPBOX_ACCESS_TOKEN =
      // 'pk.eyJ1IjoibW9ja2luZ2JpcmRzZWxpdGUiLCJhIjoiY2wwaTJ2em4wMDA0ZzNrcGtremZuM3czZyJ9.PDaTlZiPjDa7sGjF-aKnJQ'; //Mapbox api key
      'pk.eyJ1Ijoia2lraS1raWtpIiwiYSI6ImNsMHBkZmFwZDA2YnczbHBlZ2N4NGtlYmcifQ.5kF9hN-2zTBd1cj4e45PFg';

  LatLong.LatLng currentUserLoc = getLatLngFromSharedPrefs();
  List<Path> paths = [];

//[[51.4672993, -0.1209153], [-0.1398817, 51.4889993], [-0.1111645, 51.512306], [-0.1541285, 51.544682], [-0.1769325, 51.4985565]]
//-0.1209153,51.4672993;-0.1398817,51.4889993;-0.1111645,51.512306;-0.1541285,51.544682;-0.1769325,51.4985565

// https://api.mapbox.com/directions-matrix/v1/mapbox/cycling/-0.176933,51.498558;-0.13991,51.488976;-0.111055,51.512328?sources=0&destinations=1;2&annotations=distance,duration&access_token=pk.eyJ1Ijoia2lraS1raWtpIiwiYSI6ImNsMHBkZmFwZDA2YnczbHBlZ2N4NGtlYmcifQ.5kF9hN-2zTBd1cj4e45PFg

  /// Get the destinations lon and lat in a string that is possible to put in a url
  String produceDestinationString(List<DockingStation> docks) {
    List<String> resultingStr = [];
    for (var i = 0; i < docks.length; i++) {
      resultingStr.add(docks[i].lon.toString() + ",");
      resultingStr.add(docks[i].lat.toString());
      resultingStr.add(";");
    }
    resultingStr.removeLast();

    return resultingStr.join();
  }

  String produceDestinationNumberString(List<DockingStation> docks) {
    List<String> resultingStr = [];
    for (var i = 1; i < docks.length + 1; i++) {
      resultingStr.add(i.toString());
      resultingStr.add(";");
    }
    resultingStr.removeLast();

    return resultingStr.join();
  }

  /// import the dockign sttaions from the tfl api
  Future<void> importPathsForDockSorter(
      LatLong.LatLng currentUserLoc, List<DockingStation> docks) async {
    String destinationsStr = produceDestinationString(docks);
    String destinationsNumberStr = produceDestinationNumberString(docks);

    var data = await http.get(Uri.parse(
        // 'https://api.mapbox.com/directions-matrix/v1/mapbox/cycling/-0.176933,51.498558;-0.13991,51.488976;-0.111055,51.512328?sources=0&destinations=1;2&annotations=distance,duration&access_token=pk.eyJ1Ijoia2lraS1raWtpIiwiYSI6ImNsMHBkZmFwZDA2YnczbHBlZ2N4NGtlYmcifQ.5kF9hN-2zTBd1cj4e45PFg'));

        '$matrixUrl/$routingProfile/${currentUserLoc.longitude},${currentUserLoc.latitude};${destinationsStr}?sources=0&destinations=${destinationsNumberStr}&annotations=distance,duration&access_token=$YOUR_MAPBOX_ACCESS_TOKEN'));
    var jsonData = json.decode(data.body);
    paths.clear();
    //for (var i = 0; i <= 2; i++) {
    for (var i = 0; i < docks.length; i++) {
      try {
        Path newPath = Path.dock_sorter(
          currentUserLoc,
          docks[i],
          jsonData["distances"][0][i],
          jsonData["durations"][0][i],
        );

        paths.add(newPath);
      } on FormatException {}
    }
  }

  /// Sort the given paths by distance from the given location
  List<Path> sortPathsByDistanceFromGivenLocation(
      LatLong.LatLng currentUserLoc, List<Path> paths) {
    paths.sort((a, b) => a.distance.compareTo(b.distance));
    return paths;
  }

  /// Convert paths between the current user loc and a docking station to just
  /// a sorted by correct path distance from user location to the dock station ascending.
  List<DockingStation> convertPathToSortedDocks(List<Path> paths) {
    List<DockingStation> sortedDocks = [];
    for (Path path in paths) {
      sortedDocks.add(path.getDock1());
    }
    return sortedDocks;
  }
}
