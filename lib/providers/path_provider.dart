import 'dart:convert';
import 'dart:developer';
import "package:http/http.dart" as http;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/.env.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import '../models/docking_station.dart';
import '../models/path.dart';

/// A class that manages paths. It calculates the distances and duration between a single to many points, it sorts stations based on that
class PathProvider {
  String matrixUrl = 'https://api.mapbox.com/directions-matrix/v1/mapbox';
  final String routingProfile = 'cycling';

  LatLong.LatLng currentUserLoc = getLatLngFromSharedPrefs();
  List<Path> paths = [];

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
        '$matrixUrl/$routingProfile/${currentUserLoc.longitude},${currentUserLoc.latitude};${destinationsStr}?sources=0&destinations=${destinationsNumberStr}&annotations=distance,duration&access_token=$MAPBOX_ACCESS_TOKEN'));
    var jsonData = json.decode(data.body);
    this.paths.clear();
    //for (var i = 0; i <= 2; i++) {
    for (var i = 0; i < docks.length; i++) {
      try {
        Path newPath = Path.dock_sorter(
          currentUserLoc,
          docks[i],
          jsonData["distances"][0][i],
          jsonData["durations"][0][i],
        );

        this.paths.add(newPath);
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

  List<DockingStation> getSortedByPathDocks(
      LatLong.LatLng currentUserLoc, List<DockingStation> docks) {
    importPathsForDockSorter(currentUserLoc, docks);
    this.paths = sortPathsByDistanceFromGivenLocation(currentUserLoc, paths);
    return convertPathToSortedDocks(this.paths);
  }
}
