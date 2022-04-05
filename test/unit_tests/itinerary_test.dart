import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocode/geocode.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/providers/route_manager.dart';

import 'itinerary_test.mocks.dart';

/// Unit tests for itinerary class
/// Author: Nicole Lehchevska K20041914, Elisabeth Halvorsen k20077737
///
@GenerateMocks([DatabaseManager, User, DocumentSnapshot])
void main() {
  final DatabaseManager _databaseManager = MockDatabaseManager();
  DockingStation station1 =
      DockingStation("id1", "station1", true, false, 7, 10, 20, 60.11, 32.11);
  DockingStation station2 =
      DockingStation("id2", "station2", true, false, 4, 16, 20, 20.1, 32.10);
  List<DockingStation> stations = [station1, station2];

  late DocumentSnapshot user = MockDocumentSnapshot();
  LatLng currentLocation = LatLng(32.11, 60.11);
  List<LatLng> destinations = [LatLng(32.10, 60.10), LatLng(32.12, 60.12)];

  setUp(() async {});

  test('Test the .map constructor', () async {
    var now = Timestamp.now();
    var dockID = "MockDockID";
    when(user.id).thenReturn(dockID);
    when(user.get('date')).thenReturn(now);
    Itinerary it = Itinerary.map(user, stations);
    assert(it.date != null);
    expect(it.docks, stations);
    expect(it.journeyDocumentId, dockID);
  });
  test('Test the .suggestedTrip constructor', () async {
    DateTime now = DateTime.now();
    Itinerary it = Itinerary.suggestedTrip(destinations, "string", ["dd"], now);
    expect(it.myDestinations, destinations);
    assert(it.journeyDocumentId == "string");
    expect(it.date, now);
  });

  test('Test the .scheduleMap constructor', () async {
    var now = Timestamp.now();
    var dockID = "MockDockID";
    when(user.id).thenReturn(dockID);
    when(user.get('date')).thenReturn(now);
    when(user.get('points')).thenReturn(destinations);
    when(user.get('numberOfCyclists')).thenReturn(2);

    Itinerary it = Itinerary.scheduleMap(user);
    assert(it.date != null);
    expect(it.journeyDocumentId, dockID);
    assert(it.myDestinations != null);
    assert(it.numberOfCyclists != null);
  });
  test('Test the .navigation constructor', () async {
    DateTime now = DateTime.now();

    Itinerary it = Itinerary.navigation(stations, destinations, 2);
    assert(it.journeyDocumentId != null);
    assert(it.date != null);
  });
  test('Test setDocks on null', () async {
    Itinerary it = Itinerary.map(user, stations);
    it.setDocks([]);
    expect(it.docks, []);
  });
}
