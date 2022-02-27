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

class FirestoreHelper {
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference favourites =
      FirebaseFirestore.instance.collection('favourites');

  Future<void> addFavourite(String stationId) {
    return favourites
        .add({
          'user_id': getUid(),
          'station_id': stationId,
          'journeys': null,
        })
        .then((value) => print("fave Added"))
        .catchError((error) => print("Failed to add fave: $error"));
  }

  void toggleFavourite(DockingStation station) {
    addFavourite(station.id);
  }

  Future<void> deleteFavourite(favid) {
    return favourites
        .doc(favid)
        .delete()
        .then((value) => print(" Deleted"))
        .catchError((error) => print("Failed to delete fave: $error"));
  }

  Future<void> getUserFavourites() async {
    List<FavouriteDockingStation> favs = [];

    QuerySnapshot<Object?> docs =
        await favourites.where('user_id', isEqualTo: getUid()).get();
    if (docs != null) {
      for (DocumentSnapshot doc in docs.docs) {
        favs.add(FavouriteDockingStation.map(doc));
      }
    }

    //print(favs[0].stationId);
  }

  Future deleteAllFavouriteCollections() async {
    var snapshots = await favourites.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future deleteFavouriteDocument(String documentReference, String uid) async {
    await db.collection('favourites').doc(documentReference).delete();

    QuerySnapshot docs =
        await db.collection('favourites').where('userId', isEqualTo: uid).get();
  }

  Future<void> updateFavourite() {
    return favourites
        .doc('ABC123')
        .set({
          'docking_stations': null,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  bool isUserFavourite(String stationId, List faveList) {
    FavouriteDockingStation c;
    FavouriteDockingStation fave = faveList
        .firstWhere((c) => (c.stationId == stationId), orElse: () => null);

    if (fave == null)
      return false;
    else
      return true;
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
