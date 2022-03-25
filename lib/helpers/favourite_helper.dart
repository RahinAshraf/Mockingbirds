import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/services/user_services.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';

///Helper functions to add, delete or retrieve docking stations
///from and to the firestore database for a user
///@author Tayyibah
class FavouriteHelper {
  late CollectionReference _favourites;
  DatabaseManager _databaseManager = DatabaseManager();

  FavouriteHelper() {
    _favourites = _favourites =
        _databaseManager.getUserSubCollectionReference("favourites");
  }

  Future<void> addFavourite(
    String stationId,
    String name,
    int numberOfBikes,
    int numberOfEmptyDocks,
  ) {
    return _favourites
        .add({
          'stationId': stationId,
          'name': name,
          'numberOfBikes': numberOfBikes,
          'numberOfEmptyDocks': numberOfEmptyDocks,
        })
        .then((value) => print("fave Added"))
        .catchError((error) =>
            print("Failed to add fave: $error")); //add snackbar instead
  }

  Future<void> deleteFavourite(favouriteDocumentId) {
    return _favourites
        .doc(favouriteDocumentId)
        .delete()
        .then((value) => print(favouriteDocumentId))
        .catchError((error) => print("Failed to delete fave: $error"));
  }

  static Future<List<DockingStation>> getUserFavourites() async {
    List<DockingStation> favourites = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot<Object?> docs = await db
        .collection('users')
        .doc(getUid())
        .collection('favourites')
        .get();
    for (DocumentSnapshot doc in docs.docs) {
      favourites.add(DockingStation.map(doc));
    }
    return favourites;
  }

//Deletes every single favourite documents, maybe move this to settings?
  Future deleteUsersFavourites() async {
    var snapshots = await _favourites.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  bool isFavouriteStation(
      String stationId, List<DockingStation> favouriteList) {
    DockingStation? station = favouriteList
        .firstWhereOrNull((DockingStation f) => (f.stationId == stationId));
    if (station == null) {
      return false;
    } else {
      return true;
    }
  }

  void toggleFavourite(String stationId, String name, int numberOfBikes,
      int numberOfEmptyDocks) async {
    var favouriteList = await getUserFavourites();
    if (isFavouriteStation(stationId, favouriteList)) {
      DockingStation favouriteStation = favouriteList
          .firstWhere((DockingStation f) => (f.stationId == stationId));
      String? favouriteDocumentId = favouriteStation.documentId;
      await deleteFavourite(favouriteDocumentId);
    } else {
      await addFavourite(stationId, name, numberOfBikes, numberOfEmptyDocks);
    }
  }
}


///Helper functions to favourite, unfavourite or retrieve favourited docking stations
///from and to the firestore database
///Author: Tayyibah
// class FavouriteHelper {
//   late CollectionReference _favourites;
//   DatabaseManager databaseManager = DatabaseManager();

//   FavouriteHelper() {
//     _favourites = databaseManager.getUserSubCollectionReference("favourites");
//   }

//   ///Adds a docking station to a users favourites
//   Future<void> addFavourite(
//     String stationId,
//     String name,
//     int numberOfBikes,
//     int numberOfEmptyDocks,
//   ) {
//     return databaseManager.addToSubCollection(_favourites, {
//       'stationId': stationId,
//       'name': name,
//       'numberOfBikes': numberOfBikes,
//       'numberOfEmptyDocks': numberOfEmptyDocks,
//     });
//   }

//   ///Deletes a single favourited docking station
//   Future<void> deleteFavourite(favouriteDocumentId) {
//     return databaseManager.deleteDocument(_favourites, favouriteDocumentId);
//   }

//   ///Gets a list of a users favourited docking station
//   static Future<List<DockingStation>> getUserFavourites() async {
//     List<DockingStation> favourites = [];
//     var docs = await DatabaseManager().getUserSubcollection('favourites');
//     for (DocumentSnapshot doc in docs.docs) {
//       favourites.add(DockingStation.map(doc));
//     }
//     return favourites;
//   }

// //Deletes every single favourite documents
//   Future deleteUsersFavourites() async {
//     databaseManager.deleteCollection(_favourites);
//   }

//   ///Toggles between adding or removing a docking station from favourites.
//   void toggleFavourite(String stationId, String name, int numberOfBikes,
//       int numberOfEmptyDocks) async {
//     var favouriteList = await getUserFavourites();
//     if (isFavouriteStation(stationId, favouriteList)) {
//       DockingStation favouriteStation = favouriteList
//           .firstWhere((DockingStation f) => (f.stationId == stationId));
//       String? favouriteDocumentId = favouriteStation.documentId;
//       await deleteFavourite(favouriteDocumentId);
//     } else {
//       await addFavourite(stationId, name, numberOfBikes, numberOfEmptyDocks);
//     }
//   }

//   ///Checks whether a docking station is favourited or not.
//   bool isFavouriteStation(
//       String stationId, List<DockingStation> favouriteList) {
//     DockingStation? station = favouriteList
//         .firstWhereOrNull((DockingStation f) => (f.stationId == stationId));
//     if (station == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }
// }

