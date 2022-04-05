import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/providers/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary.dart';
import 'leave_unit_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  QuerySnapshot,
  DocumentSnapshot,
  ItineraryManager,
  DocumentReference<Map<String, dynamic>>,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
      unsupportedMembers: {#data}),
])
void main() {
  var docks = [
    DockingStation("test1", 'test1', true, false, 2, 2, 4, 20, 30),
    DockingStation("test2", 'test2', true, false, 2, 2, 4, 10, 10)
  ];

  late MockItineraryManager itManager;
  late MockDatabaseManager mockDBManagager;
  late Itinerary _itinerary;
  late groupManager _groupManager;
  late MockUser user;

  setUp(() {
    var points = [LatLng(20, 30), LatLng(10, 10)];
    var path = [
      Path(
          DockingStation("test1", 'test1', true, false, 2, 2, 4, 20, 30),
          DockingStation("test2", 'test2', true, false, 2, 2, 4, 10, 10),
          LatLng(20, 30),
          LatLng(10, 10))
    ];
    var numberOfCyclists = 2;
    _itinerary = Itinerary.navigation(docks, points, numberOfCyclists);
    itManager = MockItineraryManager();
    mockDBManagager = MockDatabaseManager();
    when(itManager.getPaths()).thenReturn(path);
    when(itManager.getItinerary()).thenReturn(_itinerary);
    user = MockUser();

    _groupManager = groupManager(mockDBManagager);
  });

  test('Leave group works when the current user is owner and is alone',
      () async {
    String userID = "userID";
    String username = "test";
    String groupID = "groupID";
    DocumentSnapshot<Map<String, dynamic>> userResponse =
        MockDocumentSnapshot();
    DocumentReference<Map<String, dynamic>> reference = MockDocumentReference();
    QuerySnapshot<Map<String, dynamic>> groupResponse = MockQuerySnapshot();
    var groupDoc = MockQueryDocumentSnapshot();
    List<String> memberList = [userID];
    when(user.uid).thenReturn(userID);
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> temp = [];
    temp.add(groupDoc);
    Map<String, dynamic> map = {'ownerID': userID, 'memberList': memberList};
    when(mockDBManagager.getByEquality('group', 'code', groupID))
        .thenAnswer((_) async => groupResponse);
    when(groupResponse.docs).thenReturn(temp);

    Map<String, dynamic> userMap = {'username': username};
    when(mockDBManagager.getByKey('users', userID))
        .thenAnswer((_) async => userResponse);
    when(groupResponse.size).thenReturn(0);
    when(groupDoc.data()).thenReturn(map);
    when(userResponse.data()).thenReturn(userMap);
    when(groupDoc.reference).thenReturn(reference);

    await _groupManager.leaveGroup(groupID);

    verify(reference.delete()).called(1);
    verify(mockDBManagager.updateByKey(
        'users', userID, {'group': FieldValue.delete()})).called(1);
  });
  test('Leave group works when the current user is owner and is not alone',
      () async {
    String userID = "userID";
    String username = "test";
    String otherusername = "othertest";
    String groupID = "groupID";
    String otherID = "otherID";
    DocumentSnapshot<Map<String, dynamic>> userResponse =
        MockDocumentSnapshot();
    DocumentReference<Map<String, dynamic>> reference = MockDocumentReference();
    QuerySnapshot<Map<String, dynamic>> groupResponse = MockQuerySnapshot();
    var groupDoc = MockQueryDocumentSnapshot();
    List<String> memberList = [userID, otherID];
    when(user.uid).thenReturn(userID);
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> temp = [];
    temp.add(groupDoc);
    Map<String, dynamic> map = {'ownerID': userID, 'memberList': memberList};
    when(mockDBManagager.getByEquality('group', 'code', groupID))
        .thenAnswer((_) async => groupResponse);
    when(groupResponse.docs).thenReturn(temp);

    Map<String, dynamic> userMap = {'username': username};
    Map<String, dynamic> otherMap = {'username': otherusername};
    when(mockDBManagager.getByKey('users', userID))
        .thenAnswer((_) async => userResponse);
    when(groupResponse.size).thenReturn(0);
    when(groupDoc.data()).thenReturn(map);
    when(userResponse.data()).thenReturn(userMap);
    when(userResponse.data()).thenReturn(otherMap);
    when(groupDoc.reference).thenReturn(reference);
    when(groupDoc.id).thenReturn('id');

    await _groupManager.leaveGroup(groupID);

    verify(mockDBManagager.updateByKey('group', 'id', any)).called(2);
    verify(mockDBManagager.updateByKey(
        'users', userID, {'group': FieldValue.delete()})).called(1);
  });

  test('Leave group works when the current user is not owner and is not alone',
      () async {
    String userID = "userID";
    String username = "test";
    String otherusername = "othertest";
    String groupID = "groupID";
    String otherID = "otherID";
    DocumentSnapshot<Map<String, dynamic>> userResponse =
        MockDocumentSnapshot();
    DocumentReference<Map<String, dynamic>> reference = MockDocumentReference();
    QuerySnapshot<Map<String, dynamic>> groupResponse = MockQuerySnapshot();
    var groupDoc = MockQueryDocumentSnapshot();
    List<String> memberList = [userID, otherID];
    when(user.uid).thenReturn(userID);
    when(mockDBManagager.getCurrentUser()).thenReturn(user);
    List<QueryDocumentSnapshot<Map<String, dynamic>>> temp = [];
    temp.add(groupDoc);
    Map<String, dynamic> map = {'ownerID': otherID, 'memberList': memberList};
    when(mockDBManagager.getByEquality('group', 'code', groupID))
        .thenAnswer((_) async => groupResponse);
    when(groupResponse.docs).thenReturn(temp);

    Map<String, dynamic> userMap = {'username': username};
    Map<String, dynamic> otherMap = {'username': otherusername};
    when(mockDBManagager.getByKey('users', userID))
        .thenAnswer((_) async => userResponse);
    when(groupResponse.size).thenReturn(0);
    when(groupDoc.data()).thenReturn(map);
    when(userResponse.data()).thenReturn(userMap);
    when(userResponse.data()).thenReturn(otherMap);
    when(groupDoc.reference).thenReturn(reference);
    when(groupDoc.id).thenReturn('id');

    await _groupManager.leaveGroup(groupID);

    verify(mockDBManagager.updateByKey('group', 'id', any)).called(1);
    verify(mockDBManagager.updateByKey(
        'users', userID, {'group': FieldValue.delete()})).called(1);
  });
}
