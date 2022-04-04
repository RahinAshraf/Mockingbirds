import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:collection/collection.dart';
import 'package:veloplan/models/docking_station.dart';

import '../../providers/docking_station_manager.dart';

///Helper functions to favourite, unfavourite or retrieve favourited docking stations
///from and to the firestore database
///Author: Tayyibah
class FavouriteHelper {
  late CollectionReference _favourites;
  late final DatabaseManager _databaseManager;
  var _manager = dockingStationManager();

  FavouriteHelper(this._databaseManager) {
    _favourites = _databaseManager.getUserSubCollectionReference("favourites");
  }

  ///Adds a docking station to a users favourites
  @visibleForTesting
  Future<void> addFavourite(
    String stationId,
    String name,
  ) {
    return _databaseManager.addToSubCollection(_favourites, {
      'stationId': stationId,
      'name': name,
    });
  }

  ///Deletes a single favourited docking station
  Future<void> deleteFavourite(favouriteDocumentId) {
    return _databaseManager.deleteDocument(_favourites, favouriteDocumentId);
  }

  ///Gets a list of a users favourited docking station
  Future<List<DockingStation>> getUserFavourites() async {
    List<DockingStation> favourites = [];
    var docs = await _databaseManager.getUserSubcollection('favourites');
    for (var doc in docs.docs) {
      var dock = await dockingStationManager()
          .checkStationById(doc.get('stationId'))
          .then((value) {
        favourites.add(DockingStation.map(doc, value));
      });
    }
    return favourites;
  }

//Deletes every single favourite documents
  Future deleteUsersFavourites() async {
    _databaseManager.deleteCollection(_favourites);
  }

  ///Toggles between adding or removing a docking station from favourites.
  void toggleFavourite(
      String stationId, String name, List<DockingStation> faveList) async {
    // var favouriteList = await this.getUserFavourites();
    if (isFavouriteStation(stationId, faveList)) {
      DockingStation favouriteStation =
          faveList.firstWhere((DockingStation f) => (f.stationId == stationId));
      String? favouriteDocumentId = favouriteStation.documentId;
      await deleteFavourite(favouriteDocumentId);
    } else {
      await addFavourite(stationId, name);
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
      print("yessssss");
      return true;
    }
  }
}
