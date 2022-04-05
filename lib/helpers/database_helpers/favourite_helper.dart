import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

/// Helper functions to favourite, unfavourite or retrieve favourited docking stations
/// from and to the firestore database.
/// Author: Tayyibah Uddin
class FavouriteHelper {
  late CollectionReference _favourites;
  late final DatabaseManager _databaseManager;
  var _manager = dockingStationManager();

  FavouriteHelper(this._databaseManager) {
    _favourites = _databaseManager.getUserSubCollectionReference("favourites");
  }

  /// Adds a docking station to user's favourites.
  Future<void> addFavourite(
    String stationId,
  ) {
    return _databaseManager.addToSubCollection(_favourites, {
      'stationId': stationId,
    });
  }

  /// Deletes a favourited docking station.
  Future<void> deleteFavourite(favouriteDocumentId) {
    return _databaseManager.deleteDocument(_favourites, favouriteDocumentId);
  }

  /// Gets a list of user's favourited docking stations.
  Future<List<DockingStation>> getUserFavourites() async {
    List<DockingStation> favourites = [];
    var docs = await _databaseManager.getUserSubcollection('favourites');
    for (var doc in docs.docs) {
      await _manager.checkStationById(doc.get('stationId')).then((value) {
        favourites.add(DockingStation.map(doc, value!));
      });
    }
    return favourites;
  }

  /// Deletes every single favourite documents.
  Future deleteUsersFavourites() async {
    _databaseManager.deleteCollection(_favourites);
  }

  ///Toggles between adding or removing a docking station from favourites.
  void toggleFavourite(String stationId, List<DockingStation> faveList) async {
    if (isFavouriteStation(stationId, faveList)) {
      DockingStation favouriteStation =
          faveList.firstWhere((DockingStation f) => (f.stationId == stationId));
      String? favouriteDocumentId = favouriteStation.documentId;
      await deleteFavourite(favouriteDocumentId);
    } else {
      await addFavourite(stationId);
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
