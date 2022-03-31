import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'history_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  CollectionReference<Object?>,
  QuerySnapshot<Object?>
])
main() {
  var mockDBManager = MockDatabaseManager();
  var user = MockUser();
  late MockCollectionReference<Object?> historyReference;
  late String name;
  late String stationId;
  late HistoryHelper helper;

  setUp(() {
    String userId = "name";
    name = "name";
    stationId = "station1";
    historyReference = MockCollectionReference();
    when(mockDBManager.getUserSubCollectionReference("journeys"))
        .thenAnswer((_) => historyReference);

    helper = HistoryHelper(mockDBManager);
    when(user.uid).thenReturn(userId);
    when(mockDBManager.getCurrentUser()).thenReturn(user);
  });

  test('Time of journey is saved', () {
    (verify(helper.addJourneyTime("journeyDocumentId")).called(1));
  });
}
