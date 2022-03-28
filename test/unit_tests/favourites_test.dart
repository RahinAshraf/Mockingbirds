import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/user.dart';
import 'favourites_test.mocks.dart';

@GenerateMocks([DatabaseManager, User, CollectionReference<Object?>])
main() {
  // setUp(() {
  //   var mockDBManager = MockDatabaseManager();
  //   var user = MockUser();
  //   var favouritesReference = MockCollectionReference();
  //   FavouriteHelper helper = FavouriteHelper(mockDBManager);
  // });

  test('Add favourite', () {
    var mockDBManager = MockDatabaseManager();
    var user = MockUser();
    var favouritesReference = MockCollectionReference();
    FavouriteHelper helper = FavouriteHelper(mockDBManager);

    String stationId = "id1";
    String name = "station1";
    when(mockDBManager.getUserSubCollectionReference("favourites"))
        .thenReturn(favouritesReference);

    helper.addFavourite(stationId, name);
    (verify(mockDBManager.addToSubCollection(favouritesReference, {
      'stationId': stationId,
      'name': name,
    })).called(1));
  });
}
