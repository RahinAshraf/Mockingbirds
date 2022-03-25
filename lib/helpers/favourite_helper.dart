import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';

///Helper functions to favourite, unfavourite or retrieve favourited docking stations
///from and to the firestore database
///Author: Tayyibah
class FavouriteHelper {
  late CollectionReference _favourites;
  DatabaseManager _databaseManager = DatabaseManager();

  FavouriteHelper() {
    _favourites = _favourites =
        _databaseManager.getUserSubCollectionReference("favourites");
  }

  ///Adds a docking station to a users favourites
  Future<void> addFavourite(
    String stationId,
    String name,
    int numberOfBikes,
    int numberOfEmptyDocks,
  ) {
    return _databaseManager.addToSubCollection(_favourites, {
      'stationId': stationId,
      'name': name,
      'numberOfBikes': numberOfBikes,
      'numberOfEmptyDocks': numberOfEmptyDocks,
    });
  }

  ///Deletes a single favourited docking station
  Future<void> deleteFavourite(favouriteDocumentId) {
    return _databaseManager.deleteDocument(_favourites, favouriteDocumentId);
  }

  ///Gets a list of a users favourited docking station
  static Future<List<DockingStation>> getUserFavourites() async {
    List<DockingStation> favourites = [];
    var docs = await DatabaseManager().getUserSubcollection('favourites');
    for (DocumentSnapshot doc in docs.docs) {
      favourites.add(DockingStation.map(doc));
    }
    return favourites;
  }

//Deletes every single favourite documents
  Future deleteUsersFavourites() async {
    _databaseManager.deleteCollection(_favourites);
  }

  ///Toggles between adding or removing a docking station from favourites.
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

  ///Checks whether a docking station is favourited or not.
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
}
