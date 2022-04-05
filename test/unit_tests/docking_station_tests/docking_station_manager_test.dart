// ignore_for_file: non_constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'docking_stations_values.dart';

/// Tests for docking station manager and its functionality
/// Author: Nicole Lehchevska k20041914
void main() {
  final dockingStationManager stationManager = dockingStationManager();
  dockingStationManager stationManager5Docks = dockingStationManager();
  dockingStationManager stationManager2Docks = dockingStationManager();
  dockingStationManager stationManager10Docks = dockingStationManager();
  LatLng userLocation = LatLng(51.472509, -0.122831);

  setUp(() {
    stationManager.stations.clear();
    stationManager2Docks.stations.clear();
    stationManager5Docks.stations.clear();
    stationManager10Docks.stations.clear();
    stationManager5Docks = get5DummyDocks();
    stationManager2Docks = get2DummyDocks();
    stationManager10Docks = get10DummyDocks();
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
    expect(stationManager2Docks.getClosestDock(userLocation).name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to get bikes', () {
    expect(
        stationManager2Docks
            .getClosestDockWithAvailableBikes(userLocation, 2)
            .name,
        "Binfield Road, Stockwell");
  });
  test('Get closest dock to leave bikes', () {
    expect(
        stationManager2Docks
            .getClosestDockWithAvailableSpace(userLocation, 1)
            .name,
        "Binfield Road, Stockwell");
  });

  test('Sort docs by distance from given location', () {
    expect(
        stationManager
            .sortDocksByDistanceFromGivenLocation(
                userLocation, stationManager5Docks.getStations())[1]
            .name,
        "Tallis Street, Temple");
  });
  test('Get 5 Closest docks with available bikes', () {
    expect(
        stationManager5Docks
            .get5ClosestDocksWithAvailableBikes(userLocation, 4)
            .length,
        4);
  });

  test('Get 5 Closest docks with available SPACES', () {
    expect(
        stationManager5Docks
            .get5ClosestDocksWithAvailableSpace(userLocation, 30)
            .length,
        1);
  });

  test('Sort docks from 6 given', () {
    stationManager5Docks.stations.add(DockingStation(
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
        stationManager2Docks
            .sortDocksByDistanceFromGivenLocation(
                userLocation, stationManager5Docks.getStations())[4]
            .name,
        'Hurlingham Park, Parsons Green');
  });
  test('Get 5 Closest docks', () {
    expect(stationManager5Docks.get5ClosestDocks(userLocation)[4].name,
        'Little Brook Green, Brook Green');
  });

  ///-----------------
  ///test again
  test('Get 10 Closest docks correctly', () async {
    // dockingStationManager man = dockingStationManager();
    // await man.importStations();
    expect(stationManager10Docks.stations.length, 11);
    expect(stationManager10Docks.stations[0].name, "Binfield Road, Stockwell");
    var list = stationManager10Docks.get10ClosestDocks(userLocation);
    // expect(list[0].name, "");
    // var test = stationManager10Docks.sortDocksByDistanceFromGivenLocation(
    //     userLocation, stationManager10Docks.stations);
    expect(list[0].name, "Normandy Road, Stockwell");
  });

  test('Get 10 Closest docks with less than 10 closest docking stations',
      () async {
    var list = stationManager10Docks.get10ClosestDocks(userLocation);
    list.removeLast();
    expect(list[0].name, "Normandy Road, Stockwell");
    expect(list[1].name, "Sidney Road, Stockwell");
    expect(list[2].name, "Caldwell Street, Stockwell");
    expect(list[3].name, "Teversham Lane, Stockwell");
    expect(list[4].name, "Sidney Road, Stockwell");
    expect(list[5].name, "Albert Square, Stockwell");
    expect(list[6].name, "Courland Grove, Wandsworth Road");
    expect(list[7].name, "Hartington Road, Stockwell");
    expect(list[8].name, "Normandy Road, Stockwell");
    expect(list.length, 9);
  });

  test('Get 10 Closest docks with more than than 10 closest docking stations',
      () async {
    // get random names + one more -11
    dockingStationManager man = dockingStationManager();
    await man.importStations();
    man.removeStations(10);
    expect(man.stations.length, 10);

    var list = man.get10ClosestDocks(userLocation);

    expect(list[0].name, "Sedding Street, Sloane Square");
    expect(list[1].name, "Park Street, Bankside");
    expect(list[2].name, "New Globe Walk, Bankside");
    expect(list[3].name, "Broadcasting House, Marylebone");
    expect(list[4].name, "Phillimore Gardens, Kensington");
    expect(list[5].name, "Christopher Street, Liverpool Street");
    expect(list[6].name, "River Street , Clerkenwell");
    expect(list[7].name, "St. Chad\'s Street, King\'s Cross");
    expect(list[8].name, "Charlbert Street, St. John\'s Wood");
    expect(list[9].name, "Maida Vale, Maida Vale");
  });

  test('Sort the docks by distance with given docks and user location',
      () async {
    // get random names + one more -11
    dockingStationManager man = dockingStationManager();
    await man.importStations();
    man.removeStations(10);
    expect(man.stations.length, 10);

    var list =
        man.sortDocksByDistanceFromGivenLocation(userLocation, man.stations);

    expect(list[0].name, "Sedding Street, Sloane Square");
    expect(list[1].name, "Park Street, Bankside");
    expect(list[2].name, "New Globe Walk, Bankside");
    expect(list[3].name, "Broadcasting House, Marylebone");
    expect(list[4].name, "Phillimore Gardens, Kensington");
    expect(list[5].name, "Christopher Street, Liverpool Street");
    expect(list[6].name, "River Street , Clerkenwell");
    expect(list[7].name, "St. Chad\'s Street, King\'s Cross");
    expect(list[8].name, "Charlbert Street, St. John\'s Wood");
    expect(list[9].name, "Maida Vale, Maida Vale");
  });
  test('Filter the docks by distance with given dock', () async {
    // get random names + one more -11
    dockingStationManager man = dockingStationManager();
    await man.importStations();
    man.removeStations(10);
    expect(man.stations.length, 10);

    var list = man.filterAllDockingStationsByDistance(man.stations[4]);

    expect(list[0].name, "Sedding Street, Sloane Square");
    expect(list[1].name, "Phillimore Gardens, Kensington");
    expect(list[2].name, "Broadcasting House, Marylebone");
    expect(list[3].name, "New Globe Walk, Bankside");
    expect(list[4].name, "Maida Vale, Maida Vale");
    expect(list[5].name, "Charlbert Street, St. John\'s Wood");
    expect(list[6].name, "Park Street, Bankside");
    expect(list[7].name, "St. Chad\'s Street, King\'s Cross");
    expect(list[8].name, "River Street , Clerkenwell");
    expect(list[9].name, "Christopher Street, Liverpool Street");
  });
  test('Get the closest docks with available space', () async {
    expect(
        stationManager5Docks
            .getClosestDockWithAvailableSpaceHandler(
                userLocation, 12, stationManager5Docks.stations)
            .name,
        'Binfield Road, Stockwell');
  });
  test(
      'Get the closest docks with available space, but with more spaces available',
      () async {
    stationManager5Docks.stations.removeAt(0);
    expect(
        stationManager5Docks
            .getClosestDockWithAvailableSpaceHandler(
                userLocation, 13, stationManager5Docks.stations)
            .name,
        'Hurlingham Park, Parsons Green');
    stationManager5Docks.stations.clear();
    stationManager5Docks = get5DummyDocks();
  });
  test('Send invalid api call for checkstation() ', () async {
    var d = await stationManager5Docks.checkStation(DockingStation.empty());
    expect(d.lon, DockingStation.empty().lon);
  });
  test('Send invalid api call for importStationsByRadius()', () async {
    expect(
        await stationManager5Docks.importStationsByRadius(0, userLocation), []);
  });
  test('Send invalid api call for checkStationById()', () async {
    var d = await stationManager5Docks.checkStationById("");
    expect(d!.lon, DockingStation.empty().lon);
  });
  test('Check dock with available space on an invalid call', () async {
    expect(
        await stationManager5Docks.checkDockWithAvailableSpace(
            DockingStation.empty(), 0),
        true);
  });
  test('Check dock with available bikes on an invalid call', () async {
    expect(
        await stationManager5Docks.checkDockWithAvailableBikes(
            DockingStation.empty(), 0),
        true);
  });

  test('Get 10 Closest docks fav', () async {
    // get random names + one more -11
    dockingStationManager man = dockingStationManager();
    await man.importStations();
    man.removeStations(10);
    expect(man.stations.length, 10);

    var list =
        man.get10ClosestDocksFav(userLocation, stationManager5Docks.stations);

    expect(list[0].name, "Sedding Street, Sloane Square");
    expect(list[1].name, "Park Street, Bankside");
    expect(list[2].name, "New Globe Walk, Bankside");
    expect(list[3].name, "Broadcasting House, Marylebone");
    expect(list[4].name, "Phillimore Gardens, Kensington");
    expect(list[5].name, "Christopher Street, Liverpool Street");
    expect(list[6].name, "River Street , Clerkenwell");
    expect(list[7].name, "St. Chad\'s Street, King\'s Cross");
    expect(list[8].name, "Charlbert Street, St. John\'s Wood");
    expect(list[9].name, "Maida Vale, Maida Vale");
  });

  ///filterAllDockingStationsByDistanc----- donee
  ///sortDocksByDistanceFromGivenLocatio----- done
  ///get10ClosestDocks ---------------------- done
  ///getClosestDockWithAvailableSpaceHandler ---- donee
  ///get10ClosestDocksWithAvailableBikes -- easy after i add the values
  ///get10ClosestDocksWithAvailableSpace -- easy after i add the values
  ///checkStationById --- write checkers
  ///checkDockWithAvailableSpace - write checkers
  ///checkDockWithAvailableBikes write checkers
  ///get10ClosestDocksFav
  ///importStationsByRadius --- write checkers
}
