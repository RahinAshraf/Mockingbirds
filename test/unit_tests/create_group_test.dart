// //// NEEDS FIXING

// import 'dart:collection';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:veloplan/helpers/database_helpers/database_manager.dart';
// import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
// import 'package:veloplan/models/docking_station.dart';
// import 'package:veloplan/models/itinerary.dart';
// import 'package:veloplan/screens/summary_journey_screen.dart';
// import 'create_group_test.mocks.dart';

// @GenerateMocks([DatabaseManager, User, QuerySnapshot<Map<String, dynamic>>])
// void main() {
//   var mockDBManagager = MockDatabaseManager();
//   var points = [LatLng(20, 30), LatLng(10, 10)];
//   var docks = [
//     DockingStation("test1", 'test1', true, false, 2, 2, 4, 20, 30),
//     DockingStation("test2", 'test2', true, false, 2, 2, 4, 10, 10)
//   ];
//   var user = MockUser();
//   var numberOfCyclists = 2;
//   var it = Itinerary.navigation(docks, points, numberOfCyclists);
//   QuerySnapshot<Map<String, dynamic>> groupResponse = MockQuerySnapshot();
//   SummaryJourneyScreenState _summaryJourneyScreenState =
//       SummaryJourneyScreenState(it, false, mockDBManagager);
//   test('Creating group works', () async {
//     String testID = "testingID";
//     when(user.uid).thenReturn(testID);
//     when(mockDBManagager.getCurrentUser()).thenReturn(user);
//     when(mockDBManagager.getByEquality('group', 'code', any))
//         .thenAnswer((_) async => groupResponse);
//     when(groupResponse.size).thenReturn(0);
//     when(mockDBManagager.addToCollection('group', any))
//         .thenAnswer((_) async => group);
//     when(group.collection("itinerary")).thenAnswer((_) => groupRef);
//     when(groupRef.add({
//       'journeyID': _itinerary.journeyDocumentId,
//       'points': geoList,
//       'date': _itinerary.date,
//       'numberOfCyclists': _itinerary.numberOfCyclists
//     })).thenAnswer((_) async => journey);
//     when(journey.collection('coordinates')).thenAnswer((_) => coordinatesRef);
//     when(journey.collection('dockingStations')).thenAnswer((_) => dockingRef);

//     _summaryJourneyScreenState.createGroup();
//     var Geopoints = [GeoPoint(20, 30), GeoPoint(10, 10)];
//     verify(mockDBManagager.addToCollection('group', any)).called(1);
//     verify(mockDBManagager.setByKey('users', testID, any, any)).called(1);
//   });
// }
