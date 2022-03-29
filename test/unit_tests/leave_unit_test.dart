
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'leave_unit_test.mocks.dart';
@GenerateMocks([
  DatabaseManager,
  User,
  QuerySnapshot,
  DocumentSnapshot
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(unsupportedMembers:  {#data}),
])
void main(){
  var mockDBManagager = MockDatabaseManager();
  var points = [LatLng(20, 30),LatLng(10, 10)];
  var user = MockUser();
  QuerySnapshot<Map<String, dynamic>> groupResponse =MockQuerySnapshot();
  QuerySnapshot groupDocs = MockQuerySnapshot();
  SummaryJourneyScreenState _summaryJourneyScreenState =  SummaryJourneyScreenState(mockDBManagager, points);

  test('Leave group works', () async {
    String userID = "userID";
    String groupID = "groupID";
    when(user.uid).thenReturn(userID);
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    List<QueryDocumentSnapshot<Map<String,dynamic>>> temp = [];




    when(mockDBManagager.getByEquality('group', 'code', groupID)).thenAnswer((_) async => groupResponse);
    when(groupResponse.docs).thenReturn(temp);
    when(groupResponse.size).thenReturn(0);
    await _summaryJourneyScreenState.createGroup();
    var Geopoints = [GeoPoint(20, 30),GeoPoint(10, 10)];
    verify(mockDBManagager.addToCollection('group', any)).called(1);
    verify(mockDBManagager.setByKey('users', userID, any, any)).called(1);

  });

}