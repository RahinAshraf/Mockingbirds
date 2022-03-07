import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as LatLong;

final dockingStationManager stationManager5Docks = dockingStationManager();
final dockingStationManager stationManager2Docks = dockingStationManager();

dockingStationManager get2DummyDocks() {
  stationManager2Docks.stations.clear();
  stationManager2Docks.stations.add(DockingStation(
      "447",
      "Binfield Road, Stockwell",
      true,
      false,
      3,
      31,
      35,
      51.472509,
      -0.122831));
  stationManager2Docks.stations.add(DockingStation("448",
      "Tallis Street, Temple", true, false, 24, 0, 24, 51.511891, -0.107349));
  return stationManager2Docks;
}

dockingStationManager get5DummyDocks() {
  stationManager5Docks.stations.clear();
  stationManager5Docks.stations.add(DockingStation(
      "447",
      "Binfield Road, Stockwell",
      true,
      false,
      3,
      31,
      35,
      51.472509,
      -0.122831));
  stationManager5Docks.stations.add(DockingStation("448",
      "Tallis Street, Temple", true, false, 24, 0, 24, 51.511891, -0.107349));
  stationManager5Docks.stations.add(DockingStation(
      "449",
      "Hurlingham Park, Parsons Green",
      true,
      false,
      6,
      14,
      20,
      51.470131,
      -0.20464));

  stationManager5Docks.stations.add(DockingStation(
      "450",
      "Little Brook Green, Brook Green",
      true,
      false,
      21,
      12,
      33,
      51.496664,
      -0.223868));
  stationManager5Docks.stations.add(DockingStation(
      "451",
      "Abyssinia Close, Clapham Junction",
      true,
      false,
      14,
      6,
      20,
      51.460333,
      -0.167029));
  /*
  stationManager5Docks.stations.add(DockingStation(
      "452",
      "Limburg Road, Clapham Junction",
      true,
      false,
      14,
      7,
      21,
      51.461923,
      -0.165297));*/
  return stationManager5Docks;
}
