import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/services/user_services.dart';
import 'package:collection/collection.dart';

class FavouriteHelper {
  late CollectionReference _favourites;
  late final user_id;
  late FirebaseFirestore db; //make it private, or get rid of it

  FavouriteHelper() {
    db = FirebaseFirestore.instance;
    user_id = FirebaseAuth.instance.currentUser!.uid;

    _favourites = FirebaseFirestore.instance //change to db
        .collection('users')
        .doc(user_id)
        .collection('favourites');
  }

  Future<void> addFavourite(
    String station_id,
    String name,
    String nb_bikes,
    String nb_empty_docks,
  ) {
    return _favourites
        .add({
          'station_id': station_id,
          'name': name,
          'nb_bikes': nb_bikes,
          'nb_empty_docks': nb_empty_docks,
        })
        .then((value) => print("fave Added"))
        .catchError((error) =>
            print("Failed to add fave: $error")); //add snackbar instead
  }

  Future<void> deleteFavourite(favid) {
    return _favourites
        .doc(favid)
        .delete()
        .then((value) => print(" Deleted"))
        .catchError((error) => print("Failed to delete fave: $error"));
  }

  static Future<List<FavouriteDockingStation>> getUserFavourites() async {
    List<FavouriteDockingStation> favs = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot<Object?> docs = await db
        .collection('users')
        .doc(getUid())
        .collection('favourites')
        .get();
    if (docs != null) {
      //get rid of this if statement
      for (DocumentSnapshot doc in docs.docs) {
        favs.add(FavouriteDockingStation.map(doc));
      }
    }
    return favs;
  }

//Deletes every single favourite documents, maybe move this to settings?
  Future deleteUsersFavourites() async {
    var snapshots = await _favourites.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  bool isFavouriteStation(
      String station_id, List<FavouriteDockingStation> faveList) {
    FavouriteDockingStation? fave = faveList.firstWhereOrNull(
        (FavouriteDockingStation f) => (f.station_id == station_id));
    if (fave == null) {
      return false;
    } else {
      return true;
    }
  }

  void toggleFavourite(String station_id, String name, String nb_bikes,
      String nb_empty_docks) async {
    var faveList = await getUserFavourites();
    if (isFavouriteStation(station_id, faveList)) {
      FavouriteDockingStation fave = faveList.firstWhere(
          (FavouriteDockingStation f) => (f.station_id == station_id));
      String favId = fave.id;
      await deleteFavourite(favId);
    } else {
      await addFavourite(station_id, name, nb_bikes, nb_empty_docks);
    }
  }
}
