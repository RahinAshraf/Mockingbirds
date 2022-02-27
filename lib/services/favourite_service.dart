import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutterfire_ui/firestore.dart';

CollectionReference favourites =
    FirebaseFirestore.instance.collection('favourites');

FirebaseFirestore db = FirebaseFirestore.instance;
List<String> favs = [];

Future<QuerySnapshot<Object?>> getFavouriteDocuments(String uid) async {
  QuerySnapshot docs =
      await db.collection('favourites').where('userId', isEqualTo: uid).get();
  return docs;
}

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

Future deleteAllFavouriteCollections() async {
  var snapshots = await favourites.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
}

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

Future deleteFavouriteCollection(String documentReference, String uid) async {
  await db.collection('favourites').doc(documentReference).delete();

  QuerySnapshot docs =
      await db.collection('favourites').where('userId', isEqualTo: uid).get();
}

// var getFavouriteDocumentToUser(String uid) async{
//   return await db.collection('favourites').where('userId', isEqualTo: uid).get();
// }

// Future<QuerySnapshot<Map<String, dynamic>>> test(String uid) async {
Future<List<String>> test(String uid) async {
  List<String> userFavourite = [];
  FirebaseFirestore.instance
      .collection('favourites')
      .where('user', isEqualTo: uid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) => doc.id).toList();
    // querySnapshot.docs.forEach((doc) => userFavourite.add(doc.id));
  });
  print(userFavourite.length);
  return userFavourite;

  //print(userFavourite.length);
  // return userFavourite;
}


// TOOD: fetch the current users favourites
