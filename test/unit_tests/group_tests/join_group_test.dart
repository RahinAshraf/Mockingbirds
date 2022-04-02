import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/itinerary_manager.dart';
import 'package:veloplan/models/path.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/widgets/group/group_id_join_code_widget.dart';
import 'join_group_test.mocks.dart';




@GenerateMocks(
    [
      DatabaseManager,
      User,
      QuerySnapshot<Map<String, dynamic>>,
      DocumentReference<Map<String, dynamic>>,
      CollectionReference<Map<String, dynamic>>,
      ItineraryManager,
      DocumentSnapshot<Map<String, dynamic>>,
    ],
    customMocks: [
      MockSpec<QueryDocumentSnapshot<Map<String,dynamic>>>(unsupportedMembers:  {#data}),
    ]
)
void main() {
  late MockDatabaseManager mockDBManager;
  late GroupIdState _groupIdState;

  setUp(() {
    mockDBManager = MockDatabaseManager();
   _groupIdState = GroupIdState(mockDBManager);
  });

  test('Joining existing group works', () async {
    var code = "testCode";
    var geoPoints = [GeoPoint(20, 30),GeoPoint(10, 10)];
    var numberOfCyclists = 2;
    var user = MockUser();
    var groupDoc = MockQueryDocumentSnapshot();
    var stationDoc = MockQueryDocumentSnapshot();
    var stationDoc2 = MockQueryDocumentSnapshot();
    var stationDoc3 = MockQueryDocumentSnapshot();
    var coordDoc = MockQueryDocumentSnapshot();
    var coordDoc2 = MockQueryDocumentSnapshot();
    var coordDoc3 = MockQueryDocumentSnapshot();
    var itiDoc = MockQueryDocumentSnapshot();
    DocumentReference<Map<String, dynamic>> journeyRef = MockDocumentReference();
    DocumentSnapshot<Map<String, dynamic>> journey = MockDocumentSnapshot();
    DocumentReference<Map<String, dynamic>> journeyDocRef = MockDocumentReference();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> itiList = [];
    itiList.add(itiDoc);
    CollectionReference<Map<String,dynamic>> itineraryReference = MockCollectionReference();
    CollectionReference<Map<String,dynamic>> dockingReference = MockCollectionReference();
    CollectionReference<Map<String,dynamic>> coordReference = MockCollectionReference();
    DocumentReference<Map<String,dynamic>> groupReference = MockDocumentReference();
    QuerySnapshot<Map<String, dynamic>> itiQuery = MockQuerySnapshot();
    QuerySnapshot<Map<String, dynamic>> stationCollection = MockQuerySnapshot();
    QuerySnapshot<Map<String, dynamic>> coordCollection = MockQuerySnapshot();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> temp = [];
    List<QueryDocumentSnapshot<Map<String,dynamic>>> stationList = [];
    List<QueryDocumentSnapshot<Map<String,dynamic>>> coordList = [];
    temp.add(groupDoc);
    stationList.add(stationDoc);
    stationList.add(stationDoc2);
    stationList.add(stationDoc3);
    coordList.add(coordDoc);
    coordList.add(coordDoc2);
    coordList.add(coordDoc3);
    Map<String,dynamic> journeyMap = {'numberOfCyclists': numberOfCyclists, 'points': geoPoints};
    Map<String,dynamic> stationMap = {'index': 0, 'id': "id0", 'name': 'name0', 'location': GeoPoint(20,30)};
    Map<String,dynamic> stationMap2 = {'index': 1, 'id': "id1", 'name': 'name1', 'location': GeoPoint(10,10)};
    Map<String,dynamic> stationMap3 = {'index': 2, 'id': "id2", 'name': 'name2', 'location': GeoPoint(40,-30)};
    Map<String,dynamic> coordMap = {'index': 2, 'coordinate': GeoPoint(40,-30)};
    Map<String,dynamic> coordMap2 = {'index': 1, 'coordinate': GeoPoint(10,10)};
    Map<String,dynamic> coordMap3 = {'index': 0, 'coordinate': GeoPoint(20,30)};
    Map<String,dynamic> groupMap = {'memberList': ["owner"],};
    QuerySnapshot<Map<String, dynamic>> groupResponse =MockQuerySnapshot();


    when(mockDBManager.getByEquality('group','code',code)).thenAnswer((_) async => groupResponse);
    when(groupResponse.size).thenReturn(1);
    when(groupResponse.docs).thenReturn(temp);
    when(groupDoc.reference).thenReturn(groupReference);
    when(groupReference.collection('itinerary')).thenReturn(itineraryReference);
    when(itineraryReference.get()).thenAnswer((_) async => itiQuery);
    when(itiQuery.docs).thenReturn(itiList);
    when(itiDoc.id).thenReturn("test");
    when(itineraryReference.doc("test")).thenReturn(journeyDocRef);
    when(journeyDocRef.get()).thenAnswer((_) async => journey);
    when(journey.data()).thenReturn(journeyMap);
    when(journey.reference).thenReturn(journeyRef);
    when(journeyRef.collection("dockingStations")).thenReturn(dockingReference);
    when(dockingReference.get()).thenAnswer((_) async => stationCollection);
    when(stationCollection.docs).thenReturn(stationList);
    when(stationDoc.data()).thenReturn(stationMap);
    when(stationDoc2.data()).thenReturn(stationMap2);
    when(stationDoc3.data()).thenReturn(stationMap3);
    when(journeyRef.collection("coordinates")).thenReturn(coordReference);
    when(coordReference.get()).thenAnswer((_) async => coordCollection);
    when(coordCollection.docs).thenReturn(coordList);
    when(coordDoc.data()).thenReturn(coordMap);
    when(coordDoc2.data()).thenReturn(coordMap2);
    when(coordDoc3.data()).thenReturn(coordMap3);
    when(groupDoc.data()).thenReturn(groupMap);
    when(groupDoc.id).thenReturn("id");
    when(mockDBManager.getCurrentUser()).thenReturn(user);
    when(user.uid).thenReturn("testingID");

    await _groupIdState.joinGroup(code);

    verify(mockDBManager.setByKey('users', 'testingID', any,any)).called(1);
    verify(mockDBManager.updateByKey('group', 'id', any));
















  });


}
