import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';


void main() {
  final dockingStationManager stationManager = dockingStationManager();

  setUp((){
    stationManager.stations.clear();
  });

  test('Calling method on empty list works', () {
    expect(stationManager.get_all_open_stations().length, 0);
    expect(stationManager.get_all_stations_with_number_of_bikes(0).length, 0);
    expect(stationManager.get_all_stations_with_number_empty_docks(0) .length, 0);
  });

  test('Locked station is not returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, true, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_open_stations().length, 0);
  });

  test('Open station is returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, true, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_open_stations().length, 1);
  });

  test('Station with less than the specified bike number is not returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(11).length, 0);
  });

  test('Station with more than the specified bike number is returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(9).length, 1);
  });

  test('Station with the specified bike number is returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(10).length, 1);
  });

  test('Station with less than the specified empty number is not returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(11).length, 0);
  });

  test('Station with more than the specified empty number is returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(9).length, 1);
  });

  test('Station with the specified empty number is returned', () {
    stationManager.stations.add(DockingStation("test", "test", true, false, 10, 10, 20, 1, 1));
    expect(stationManager.get_all_stations_with_number_of_bikes(10).length, 1);
  });
}