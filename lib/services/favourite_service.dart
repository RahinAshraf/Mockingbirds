import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:veloplan/services/user_services.dart';
import 'package:collection/collection.dart';

class FirestoreHelper {
  late CollectionReference favourites;
  late final userID;
  late FirebaseFirestore db;

  //change these to var?

  FirestoreHelper() {
    db = FirebaseFirestore.instance;
    userID = FirebaseAuth.instance.currentUser!.uid;

    favourites = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('favourites');
  }

  Future<void> addFavourite(String stationId) {
    return favourites
        .add({
          'user_id': getUid(),
          'station_id': stationId,
          //'journeys': null,
        })
        .then((value) => print("fave Added"))
        .catchError((error) => print("Failed to add fave: $error"));
  }

  Future<void> deleteFavourite(favid) {
    return favourites
        .doc(favid)
        .delete()
        .then((value) => print(" Deleted"))
        .catchError((error) => print("Failed to delete fave: $error"));
  }

//refactor this method it does way too much
  static Future<List<FavouriteDockingStation>> getUserFavourites() async {
    List<FavouriteDockingStation> favs = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot<Object?> docs = await db
        .collection('users')
        .doc(getUid())
        .collection('favourites')
        .get();
    if (docs != null) {
      for (DocumentSnapshot doc in docs.docs) {
        favs.add(FavouriteDockingStation.map(doc));
      }
    }
    return favs;
  }

//Deletes every single favourite documents, maybe move this to settings?
  Future deleteUsersFavourites() async {
    var snapshots = await favourites.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

//Deletes a specifc document for a given user.
  Future deleteFavouriteDocument(String documentReference, String uid) async {
    await db.collection('favourites').doc(documentReference).delete();

    QuerySnapshot docs =
        await db.collection('favourites').where('userId', isEqualTo: uid).get();
  }

//this needs to be fixed:
  Future<void> updateFavourite() {
    return favourites
        .doc('ABC123')
        .set({
          'docking_stations': null,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//checks if a given station has been favourited.
  bool isFavouriteStation(
      String stationId, List<FavouriteDockingStation> faveList) {
    //checks if the station id is in the list of faves.
    FavouriteDockingStation? fave = faveList.firstWhereOrNull(
        (FavouriteDockingStation f) => (f.stationId == stationId));
    if (fave == null) {
      print("NOOOOOOOOOOOO");
      return false;
    } else {
      print("YEEEEEEEEEEEES");
      return true;
    }
  }

  toggleFavourite(
    String stationId,
  ) async {
    FirestoreHelper helper = FirestoreHelper();
    var faveList = await getUserFavourites();
    if (isFavouriteStation(stationId, faveList)) {
      //refactor this:
      FavouriteDockingStation fave = faveList.firstWhere(
          (FavouriteDockingStation f) => (f.stationId == stationId));
      String favId = fave.id;
      await helper.deleteFavourite(favId);
      print("deleted");
    } else {
      await helper.addFavourite(stationId);
      print("added");
    }
    //faveList = await getUpdatedList();
  }

  Future<List<FavouriteDockingStation>> getUpdatedList() async {
    List<FavouriteDockingStation> updatedFavourites =
        await FirestoreHelper.getUserFavourites();
    return updatedFavourites;
  }
}

// List<String> favs = [];

// Future<QuerySnapshot<Object?>> getFavouriteDocuments(String uid) async {
//   QuerySnapshot docs =
//       await db.collection('favourites').where('userId', isEqualTo: uid).get();
//   return docs;
// }

// Future<void> deleteFav()async{
//   favourites.getDocuments().then((snapshot) {
//   for (DocumentSnapshot ds in snapshot.documents){
//     ds.reference.delete();
//   };
// });
// }

//  Future<List<FavouriteDockingStation>> getUserFavourites(String uid) async {
//     List<FavouriteDockingStation> favs = [];
//     QuerySnapshot docs = await db.collection('favourites')
//       .where('userId', isEqualTo: uid).get();
//     if (docs != null) {
//       for (DocumentSnapshot doc in docs.documents) {
//         favs.add(Favourite.map(doc));
//       }
//     }
//     return favs;
//   }

// Future deleteAllFavouriteCollectionsUser(String uid) async {
//   // print("hello");
//   var snapshots =
//       await db.collection('favourites').where('userId', isEqualTo: uid).get();
//   print(snapshots.size);
//   for (var doc in snapshots.docs) {
//     print(doc);
//     await doc.reference.delete();
//   }
// }

// var getFavouriteDocumentToUser(String uid) async{
//   return await db.collection('favourites').where('userId', isEqualTo: uid).get();
// }

// Future<QuerySnapshot<Map<String, dynamic>>> test(String uid) async {
// Future<List<String>> test(String uid) async {
//   List<String> userFavourite = [];
//   FirebaseFirestore.instance
//       .collection('favourites')
//       .where('user', isEqualTo: uid)
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     return querySnapshot.docs.map((doc) => doc.id).toList();
//     // querySnapshot.docs.forEach((doc) => userFavourite.add(doc.id));
//   });
//   print(userFavourite.length);
//   return userFavourite;

//print(userFavourite.length);
// return userFavourite;

// TOOD: fetch the current users favourites
