
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

import 'create_group_test.mocks.dart';
@GenerateMocks([DatabaseManager, User,QuerySnapshot<Map<String, dynamic>>])
void main(){
  var mockDBManagager = MockDatabaseManager();
  var points = [LatLng(20, 30),LatLng(10, 10)];
  var user = MockUser();
  QuerySnapshot<Map<String, dynamic>> groupResponse =MockQuerySnapshot();
  SummaryJourneyScreenState _summaryJourneyScreenState =  SummaryJourneyScreenState(mockDBManagager, points);
  test('Creating group works', () async {
    when(user.uid).thenReturn("testingID");
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    when(mockDBManagager.getByEquality('group', 'code', any)).thenAnswer((_) async => groupResponse);
    when(groupResponse.size).thenReturn(0);
   await _summaryJourneyScreenState.createGroup();
    var Geopoints = [GeoPoint(20, 30),GeoPoint(10, 10)];
    expect( verify(mockDBManagager.addToCollection('group', captureAny )).captured, {
      'code': any,
      'ownerID': "testingID",
      'memberList': ["testingID"],
      'createdAt': any,
      'points': Geopoints,
    })
   ;
    verify(mockDBManagager.setByKey(
    'users', "testingID", {'group': any}, SetOptions(merge: true))).called(1);

  });

}