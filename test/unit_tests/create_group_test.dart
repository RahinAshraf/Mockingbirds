
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'create_group_test.mocks.dart';
@GenerateMocks([DatabaseManager, User,QuerySnapshot<Map<String, dynamic>>, DocumentReference<Map<String, dynamic>>, CollectionReference<Map<String, dynamic>>])
void main(){
  var mockDBManagager = MockDatabaseManager();
  var points = [LatLng(20, 30),LatLng(10, 10)];
  var docks = [DockingStation("test1", 'test1', true, false, 2, 2, 4, 20, 30),DockingStation("test2", 'test2', true, false, 2, 2, 4, 10, 10) ];
  var user = MockUser();
  var numberOfCyclists = 2;
  DocumentReference<Map<String, dynamic>> group = MockDocumentReference();
  DocumentReference<Map<String, dynamic>>  journey = MockDocumentReference();
  CollectionReference<Map<String, dynamic>> groupRef = MockCollectionReference();
  CollectionReference<Map<String, dynamic>> dockingRef = MockCollectionReference();
  CollectionReference<Map<String, dynamic>> coordinatesRef = MockCollectionReference();
  var _itinerary = Itinerary.navigation(docks, points,numberOfCyclists);
  QuerySnapshot<Map<String, dynamic>> groupResponse =MockQuerySnapshot();
  SummaryJourneyScreenState _summaryJourneyScreenState =  SummaryJourneyScreenState(_itinerary,false, mockDBManagager);
  List<GeoPoint> geoList = [];
  var destinationsIndouble = convertLatLngToDouble(_itinerary.myDestinations!);
  for (int i = 0; i < destinationsIndouble!.length; i++) {
    geoList.add(
        GeoPoint(destinationsIndouble[i]![0]!, destinationsIndouble[i]![1]!));
  }

  test('Creating group works', () async {
    String testID = "testingID";
    when(user.uid).thenReturn(testID);
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    when(mockDBManagager.getByEquality('group', 'code', any)).thenAnswer((_) async => groupResponse);
    when(groupResponse.size).thenReturn(0);
    when(mockDBManagager.addToCollection('group', any)).thenAnswer((_) async => group);
    when (group.collection("itinerary")).thenAnswer((_) => groupRef);
    when(groupRef.add({
      'journeyID': _itinerary.journeyDocumentId,
      'points': geoList,
      'date': _itinerary.date,
      'numberOfCyclists': _itinerary.numberOfCyclists
    })).thenAnswer((_) async => journey);
    when(journey.collection('coordinates')).thenAnswer((_) => coordinatesRef);
    when(journey.collection('dockingStations')).thenAnswer((_) => dockingRef);

    _summaryJourneyScreenState.createGroup();
    for(int j = 0; j< geoList.length; j++) {
      var geo = geoList[j];
      when(coordinatesRef.add({
        'coordinate': geo,
        'index': j,
      })).thenAnswer((_)async => journey);
      verify(coordinatesRef.add({
        'coordinate': geo,
        'index': j,
      })).called(1);
    }
    for (int i = 0; i < docks.length; i++) {
      var station = docks[i];
      when(dockingRef.add({
        'id': station.stationId,
        'name': station.name,
        'location': GeoPoint(station.lat, station.lon),
        'index':i,
      })).thenAnswer((_)async => journey);
      verify(dockingRef.add({
        'id': station.stationId,
        'name': station.name,
        'location': GeoPoint(station.lat, station.lon),
        'index':i,
      })).called(1);
    }
    verify(mockDBManagager.addToCollection('group', any)).called(1);
    verify(mockDBManagager.setByKey('users', testID, any, any)).called(1);

  });

}
