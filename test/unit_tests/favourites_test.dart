import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'favourites_test.mocks.dart';
import 'mock.dart';

@GenerateMocks([
  DatabaseManager,
  User,
  CollectionReference<Object?>,
  QuerySnapshot<Object?>
])
main() {
  var mockDBManager = MockDatabaseManager();
  var user = MockUser();
  late MockCollectionReference<Object?> favouritesReference;
  late MockQuerySnapshot<Object?> favouriteDocs;
  late String name;
  late String stationId;
  late FavouriteHelper helper;

  DockingStation station1 =
      DockingStation("id1", "station1", true, false, 7, 10, 20, 60.11, 32.11);
  DockingStation station2 =
      DockingStation("id2", "station2", true, false, 4, 16, 20, 20.1, 32.10);
  List<DockingStation> favouriteList = [station1, station2];

  setUp(() {
    String userId = "name";
    name = "name";
    stationId = "station1";
    favouritesReference = MockCollectionReference();
    when(mockDBManager.getUserSubCollectionReference("favourites"))
        .thenAnswer((_) => favouritesReference);
    favouriteDocs = MockQuerySnapshot<Object?>();

    helper = FavouriteHelper(mockDBManager);

    when(user.uid).thenReturn(userId);
    when(mockDBManager.getCurrentUser()).thenReturn(user);
  });

  // test('Get user favourites', () async {
  //   when(mockDBManager.getUserSubcollection("favourites"))
  //       .thenAnswer((_) async => favouriteDocs);

  // });

  test('Add to favourites', () {
    helper.addFavourite(stationId, name);
    (verify(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': stationId,
      'name': name,
    })).called(1));
  });

  test('Delete from favourites', () {
    helper.deleteFavourite("favouriteDocumentId");
    (verify(mockDBManager.deleteDocument(
            favouritesReference, "favouriteDocumentId"))
        .called(1));
  });

  test('Get user favourites', () {
    helper.deleteFavourite("favouriteDocumentId");
    (verify(mockDBManager.deleteDocument(
            favouritesReference, "favouriteDocumentId"))
        .called(1));
  });

  test('Returns true if station is in users favourites', () {
    String stationId = "id1";
    bool result = helper.isFavouriteStation(stationId, favouriteList);
    expect(result, true);
  });

  test('Returns false if a station is not in users favourites', () {
    String stationId = "id3";
    bool result = helper.isFavouriteStation(stationId, favouriteList);
    expect(result, false);
  });
}
