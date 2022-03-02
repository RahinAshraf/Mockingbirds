// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../unit_tests/docking_stations_values.dart';

void main() {
  final dockingStationManager stationManager = dockingStationManager();
  dockingStationManager stationManager_5_docks = dockingStationManager();
  dockingStationManager stationManager_2_docks = dockingStationManager();
  LatLng user_location = LatLng(51.472509, -0.122831);

  setUp(() {
    stationManager.stations.clear();
    stationManager_2_docks.stations.clear();
    stationManager_5_docks.stations.clear();
    stationManager_5_docks = get_5_dummy_docks();
    stationManager_2_docks = get_2_dummy_docks();
  });

  test('Calling method on empty list works', () {
    expect(stationManager.getAllOpenStations().length, 0);
    expect(stationManager.getAllStationsWithAvailableBike(0).length, 0);
    expect(stationManager.getAllStationsWithAvailableSpace(0).length, 0);
  });

  test('Locked station is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, true, 10, 10, 20, 1, 1));
    expect(stationManager.getAllOpenStations().length, 0);
  });

  test('Open station is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllOpenStations().length, 1);
  });

  test('Station with less than the specified bike number is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(11).length, 0);
  });

  test('Station with more than the specified bike number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(9).length, 1);
  });

  test('Station with the specified bike number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(10).length, 1);
  });

  test('Station with less than the specified empty number is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(11).length, 0);
  });

  test('Station with more than the specified empty number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(9).length, 1);
  });

  test('Station with the specified empty number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.getAllStationsWithAvailableBike(10).length, 1);
  });

  test('Filter the stations by distance by given doc', () {
    expect(stationManager_2_docks.getClosestDock(user_location).name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to get bikes', () {
    expect(
        stationManager_2_docks
            .getClosestDockWithAvailableBikes(user_location, 2)
            .name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to leave bikes', () {
    expect(
        stationManager_2_docks
            .getClosestDockWithAvailableSpace(user_location, 1)
            .name,
        "Binfield Road, Stockwell");
  });

  test('Sort docs by distance from given location', () {
    expect(
        stationManager
            .sortDocsByDistanceFromGivenLocation(
                user_location, stationManager_5_docks.getStations())[1]
            .name,
        "Tallis Street, Temple");
  });
  test('Get 5 Closest docks with available bikes', () {
    expect(
        stationManager_5_docks
            .get5ClosestDocksWithAvailableBikes(user_location, 4)
            .length,
        4);
  });

  test('Get 5 Closest docks with available SPACES', () {
    expect(
        stationManager_5_docks
            .get5ClosestDocksWithAvailableSpace(user_location, 30)
            .length,
        1);
  });

  test('Sort docks from 6 given', () {
    stationManager_5_docks.stations.add(DockingStation(
        "452",
        "Limburg Road, Clapham Junction",
        true,
        false,
        14,
        7,
        21,
        51.461923,
        -0.165297));
    expect(
        stationManager_5_docks
            .sortDocsByDistanceFromGivenLocation(
                user_location, stationManager_5_docks.getStations())[4]
            .name,
        'Hurlingham Park, Parsons Green');
  });
  test('Get 5 Closest docks', () {
    expect(stationManager_5_docks.get5ClosestDocks(user_location)[4].name,
        'Little Brook Green, Brook Green');
  });
}
