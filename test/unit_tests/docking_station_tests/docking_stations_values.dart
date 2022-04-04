import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

/// Premade dummy values for docking station mamager to test its functionality.
/// Author: Nicole Lehchevska k20041914
final dockingStationManager stationManager5Docks = dockingStationManager();
final dockingStationManager stationManager2Docks = dockingStationManager();
final dockingStationManager stationManager10Docks = dockingStationManager();

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

dockingStationManager get10DummyDocks() {
  stationManager10Docks.stations.clear();
  stationManager10Docks.stations.add(DockingStation(
      "447",
      "Binfield Road, Stockwell",
      true,
      false,
      3,
      31,
      35,
      51.472509,
      -0.122831));
  stationManager10Docks.stations.add(DockingStation(
      "452",
      "Clapham Road, Lingham Street, Stockwell",
      true,
      false,
      24,
      0,
      24,
      51.471433,
      -0.12367));
  stationManager10Docks.stations.add(DockingStation(
      "453",
      "Teversham Lane, Stockwell",
      true,
      false,
      6,
      14,
      20,
      51.476149,
      -0.123258));

  stationManager10Docks.stations.add(DockingStation(
      "454",
      "Caldwell Street, Stockwell",
      true,
      false,
      21,
      12,
      33,
      51.477839,
      -0.116493));
  stationManager10Docks.stations.add(DockingStation(
      "455",
      "Hartington Road, Stockwell",
      true,
      false,
      14,
      6,
      20,
      51.47787,
      -0.126874));

  stationManager10Docks.stations.add(DockingStation("456",
      "Normandy Road, Stockwell", true, false, 14, 7, 21, 51.473874, -0.11258));
  stationManager10Docks.stations.add(DockingStation(
      "457",
      "Clarence Walk, Stockwell",
      true,
      false,
      14,
      7,
      21,
      51.470732,
      -0.126994));
  stationManager10Docks.stations.add(DockingStation(
      "458",
      "Courland Grove, Wandsworth Road",
      true,
      false,
      14,
      7,
      21,
      51.472918,
      -0.132102));
  stationManager10Docks.stations.add(DockingStation("459",
      "Albert Square, Stockwell", true, false, 14, 7, 21, 51.47659, -0.118256));
  stationManager10Docks.stations.add(DockingStation("460",
      "Sidney Road, Stockwell", true, false, 14, 7, 21, 51.469202, -0.119022));
  stationManager10Docks.stations.add(DockingStation(
      "461",
      "Limburg Road, Clapham Junction",
      true,
      false,
      14,
      7,
      21,
      51.461923,
      -0.165297));
  return stationManager10Docks;
}
