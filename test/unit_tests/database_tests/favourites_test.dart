import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'favourites_test.mocks.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  CollectionReference<Object?>,
  DocumentSnapshot,
  QuerySnapshot<Object?>
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(unsupportedMembers: {#data}),
])
main() {
  var mockDBManager = MockDatabaseManager();
  var user = MockUser();
  late MockCollectionReference<Object?> favouritesReference;
  late FavouriteHelper helper;

  DockingStation station1 = DockingStation(
      "bikepoints1", "limehouse", true, false, 7, 10, 20, 60.11, 32.11);
  DockingStation station2 = DockingStation(
      "bikepoints2", "stepney", true, false, 4, 16, 20, 20.1, 32.10);

  station1.setDocumentId = "1234";
  station2.setDocumentId = "5678";

  List<DockingStation> favouriteList = [station1, station2];

  setUp(() {
    favouritesReference = MockCollectionReference();
    when(mockDBManager.getUserSubCollectionReference("favourites"))
        .thenAnswer((_) => favouritesReference);
    helper = FavouriteHelper(mockDBManager);
    when(user.uid).thenReturn("bob");
    when(mockDBManager.getCurrentUser()).thenReturn(user);
  });

  test('Toggling favourited docking station deletes it from database', () {
    helper.toggleFavourite("bikepoints1", favouriteList);

    (verify(mockDBManager.deleteDocument(
            favouritesReference, station1.documentId))
        .called(1));

    (verifyNever(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': "bikepoints1",
      'name': "limehouse",
    })));
  });

  test('Toggling new docking station adds to database', () async {
    helper.toggleFavourite("bikepoints3", favouriteList);

    (verifyNever(mockDBManager.deleteDocument(favouritesReference, any)));

    (verify(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': "bikepoints3",
      'name': "london bridge",
    })).called(1));
  });
  test('Add to favourites correctly calls the database', () {
    helper.addFavourite("new station id");
    (verify(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': "new station id",
      'name': "new name",
    })).called(1));
  });

  test('Delete from favourites correctly calls the database', () {
    helper.deleteFavourite("favouriteDocumentId");
    (verify(mockDBManager.deleteDocument(
            favouritesReference, "favouriteDocumentId"))
        .called(1));
  });

  test('Returns true if station is in users favourites', () {
    bool result = helper.isFavouriteStation("bikepoints1", favouriteList);
    expect(result, true);
  });

  test('Returns false if a station is not in users favourites', () {
    bool result = helper.isFavouriteStation("new station id", favouriteList);
    expect(result, false);
  });
}
