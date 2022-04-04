import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/providers/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import 'join_group_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  QuerySnapshot<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  CollectionReference<Map<String, dynamic>>,
  ItineraryManager
])
void main() {
  late MockItineraryManager itManager;
  late String userID;
  late MockDatabaseManager _databaseManager;
  late Itinerary _itinerary;
  late MockUser user;
  late groupManager _groupManager;

  var docks = [
    DockingStation("test1", 'test1', true, false, 2, 2, 4, 20, 30),
    DockingStation("test2", 'test2', true, false, 2, 2, 4, 10, 10)
  ];

  setUp(() {
    _databaseManager = MockDatabaseManager();
    _groupManager = groupManager(_databaseManager);
    user = MockUser();
  });

  test('deleting group works', () async {
    DocumentSnapshot<Map<String, dynamic>> userResponse =
        MockDocumentSnapshot();
    QuerySnapshot<Map<String, dynamic>> groupResponse = MockQuerySnapshot();
    var userID = "test";
    var groupCode = "groupCode";
    QueryDocumentSnapshot<Map<String, dynamic>> groupdoc =
        MockQueryDocumentSnapshot();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list = [];
    DocumentReference<Map<String, dynamic>> groupDocRef =
        MockDocumentReference();
    list.add(groupdoc);
    List<String> memberList = [userID];
    Map<String, dynamic> userMap = {'group': groupCode};
    Map<String, dynamic> groupMap = {
      'createdAt': Timestamp.fromDate(
          Timestamp.now().toDate().subtract(Duration(days: 3))),
      'memberList': memberList
    };
    var userKeys = ['group'];
    when(_databaseManager.getCurrentUser()).thenReturn(user);
    when(user.uid).thenReturn(userID);
    when(_databaseManager.getByKey('users', userID))
        .thenAnswer((_) async => userResponse);
    when(userResponse.data()).thenReturn(userMap);
    when(_databaseManager.getByEquality('group', 'code', groupCode))
        .thenAnswer((_) async => groupResponse);
    when(groupResponse.docs).thenReturn(list);
    when(groupdoc.reference).thenReturn(groupDocRef);
    when(groupdoc.data()).thenReturn(groupMap);
    await _groupManager.deleteOldGroup();
    verify(groupDocRef.delete()).called(1);
    verify(_databaseManager.setByKey('users', userID, any, any)).called(1);
  });
}
