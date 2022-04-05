import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'history_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  CollectionReference<Object?>,
  QuerySnapshot<Object?>,
  DocumentReference<Object?>
])
main() {
  var mockDBManager = MockDatabaseManager();

  MockDocumentReference documentReference = MockDocumentReference();
  var user = MockUser();
  late MockCollectionReference<Object?> historyReference;
  late String name;
  late String stationId;
  late HistoryHelper helper;

  DockingStation station1 =
      DockingStation("id1", "station1", true, false, 7, 10, 20, 60.11, 32.11);
  DockingStation station2 =
      DockingStation("id2", "station2", true, false, 4, 16, 20, 20.1, 32.10);
  List<DockingStation> historyList = [station1, station2];

  setUp(() {
    historyReference = MockCollectionReference();
    when(mockDBManager.getUserSubCollectionReference("journeys"))
        .thenAnswer((_) => historyReference);

    helper = HistoryHelper(mockDBManager);
    when(user.uid).thenReturn("margaret");
    when(mockDBManager.getCurrentUser()).thenReturn(user);
  });

  test('Time of journey is saved', () {
    helper.addJourneyTime("journeyDocumentId");
    verify(mockDBManager.setSubCollectionByDocumentId(
            "journeyDocumentId", historyReference, any))
        .called(1);
  });

  test('Add docking station subcollection to database', () async {
    helper.addDockingStation(station1, "documentId");
    verify(mockDBManager.addSubCollectiontoSubCollectionByDocumentId(
        "documentId", "docking_stations", historyReference, {
      'stationId': station1.stationId,
    })).called(1);
  });

  test('Add all docking station in list to database', () async {
    when(historyReference.doc()).thenReturn(documentReference);
    String documentId = "";
    when(documentReference.id).thenReturn(documentId);
    helper.createJourneyEntry(historyList);
    verify(mockDBManager.addSubCollectiontoSubCollectionByDocumentId(
            documentId, "docking_stations", historyReference,{ 'stationId':station1.stationId}))
        .called(1);
  });
}
