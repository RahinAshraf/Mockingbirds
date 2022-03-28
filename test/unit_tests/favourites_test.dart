import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'favourites_test.mocks.dart';
import 'mock.dart';

@GenerateMocks([DatabaseManager, User, CollectionReference<Object?>])
main() {
  setUp(() {});

  test('Add favourite', () {
    var mockDBManager = MockDatabaseManager();
    var user = MockUser();
    var favouritesReference = MockCollectionReference();
    when(mockDBManager.getUserSubCollectionReference("favourites"))
        .thenAnswer((_) => favouritesReference);

    FavouriteHelper helper = FavouriteHelper(mockDBManager);

    String testID = "name";

    when(user.uid).thenReturn(testID);
    when(mockDBManager.getCurrentUser()).thenReturn(user);
    String stationId = "id1";
    String name = "station1";

    helper.addFavourite(stationId, name);
    (verify(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': stationId,
      'name': name,
    })).called(1));
  });
}
