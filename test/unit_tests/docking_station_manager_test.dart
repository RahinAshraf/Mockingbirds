// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:latlong2/latlong.dart' as LatLong;
import '../unit_tests/docking_stations_values.dart';

void main() {
  final dockingStationManager stationManager = dockingStationManager();
  LatLng user_location = LatLng(51.472509, -0.122831);

  setUp(() {
    stationManager.stations.clear();
    dockingStationManager stationManager_5_docks = get_5_dummy_docks();
    dockingStationManager stationManager_2_docks = get_2_dummy_docks();
  });

  test('Calling method on empty list works', () {
    expect(stationManager.get_all_open_stations().length, 0);
    expect(stationManager.get_all_stations_with_number_of_bikes(0).length, 0);
    expect(
        stationManager.get_all_stations_with_number_empty_docks(0).length, 0);
  });

  test('Locked station is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, true, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_open_stations().length, 0);
  });

  test('Open station is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, true, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_open_stations().length, 1);
  });

  test('Station with less than the specified bike number is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(11).length, 0);
  });

  test('Station with more than the specified bike number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(9).length, 1);
  });

  test('Station with the specified bike number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(10).length, 1);
  });

  test('Station with less than the specified empty number is not returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(11).length, 0);
  });

  test('Station with more than the specified empty number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(9).length, 1);
  });

  test('Station with the specified empty number is returned', () {
    stationManager.stations
        .add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(10).length, 1);
  });

  test('Filter the stations by distance by given doc', () {
    expect(stationManager_2_docks.get_closest_dock(user_location).name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to get bikes', () {
    expect(
        stationManager_2_docks
            .get_closest_dock_to_get_bikes(user_location, 2)
            .name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to leave bikes', () {
    expect(
        stationManager_2_docks
            .get_closest_dock_to_get_bikes(user_location, 1)
            .name,
        "Binfield Road, Stockwell");
  });

  test('Sort docs by distance from given location', () {
    expect(
        stationManager
            .sort_docs_by_distance_from_loc(
                user_location, stationManager_5_docks.getStations())[1]
            .name,
        "Tallis Street, Temple");
  });
}
