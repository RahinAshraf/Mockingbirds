import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as LatLong;

final dockingStationManager stationManager_5_docks = dockingStationManager();
final dockingStationManager stationManager_2_docks = dockingStationManager();

dockingStationManager get_2_dummy_docks() {
  stationManager_2_docks.stations.clear();
  stationManager_2_docks.stations.add(DockingStation(
      "447",
      "Binfield Road, Stockwell",
      true,
      false,
      3,
      31,
      35,
      51.472509,
      -0.122831));
  stationManager_2_docks.stations.add(DockingStation("448",
      "Tallis Street, Temple", true, false, 24, 0, 24, 51.511891, -0.107349));
  return stationManager_2_docks;
}

dockingStationManager get_5_dummy_docks() {
  stationManager_5_docks.stations.clear();
  stationManager_5_docks.stations.add(DockingStation(
      "447",
      "Binfield Road, Stockwell",
      true,
      false,
      3,
      31,
      35,
      51.472509,
      -0.122831));
  stationManager_5_docks.stations.add(DockingStation("448",
      "Tallis Street, Temple", true, false, 24, 0, 24, 51.511891, -0.107349));
  stationManager_5_docks.stations.add(DockingStation(
      "449",
      "Hurlingham Park, Parsons Green",
      true,
      false,
      6,
      14,
      20,
      51.470131,
      -0.20464));

  stationManager_5_docks.stations.add(DockingStation(
      "450",
      "Little Brook Green, Brook Green",
      true,
      false,
      21,
      12,
      33,
      51.496664,
      -0.223868));
  stationManager_5_docks.stations.add(DockingStation(
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
  stationManager_5_docks.stations.add(DockingStation(
      "452",
      "Limburg Road, Clapham Junction",
      true,
      false,
      14,
      7,
      21,
      51.461923,
      -0.165297));*/
  return stationManager_5_docks;
}
