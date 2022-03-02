// // ignore_for_file: non_constant_identifier_names

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'docking2.dart';
// import '../services/user_services.dart';

// ///Adds a station to current users favourite

// class FavouriteDockingStation {
//   late String id;
//   late String uid;
//   late String station_id;
//   List<FavouriteDockingStation> favs = []; //just testing

//   CollectionReference favourites =
//       FirebaseFirestore.instance.collection('favourites');

//   FavouriteDockingStation(this.id, this.station_id) {
//     uid = getUid();
//     addFavourite();
//     //getUserFavourites();
//     //print(_getFavoriteIDs);
//   }

//   FavouriteDockingStation.map(DocumentSnapshot document) {
//     this.id = document.id;
//     this.uid = document.get('user_id');
//     this.station_id = document.get('stationId');
//   }

//   Map toMap() {
//     Map map = Map<String, dynamic>();
//     if (id != null) {
//       map['id'] = id;
//     }
//     map['station_id'] = station_id;
//     map['user_id'] = uid;
//     return map;
//   }

//   Future<void> addFavourite() {
//     // Call the user's CollectionReference to add a new user
//     return favourites
//         .add({
//           'user_id': uid, // John Doe
//           'station_id': station_id, // Stokes and Sons
//           'journeys': null // 42
//         })
//         .then((value) => print("fave Added"))
//         .catchError((error) => print("Failed to add fave: $error"));
//   }

//   Future<void> deleteFavourite(favid) {
//     return favourites
//         .doc(favid)
//         .delete()
//         .then((value) => print(" Deleted"))
//         .catchError((error) => print("Failed to delete fave: $error"));
//   }

//   Future<void> getUserFavourites() async {
//     List<FavouriteDockingStation> favs = [];

//     QuerySnapshot<Object?> docs =
//         await favourites.where('user_id', isEqualTo: uid).get();
//     if (docs != null) {
//       for (DocumentSnapshot doc in docs.docs) {
//         favs.add(FavouriteDockingStation.map(doc));
//       }
//     }

//     //print(favs[0].station_id);
//   }

// void addToList(FavouriteDockingStation station) {
//   favs.add(station);
// }

// List<FavouriteDockingStation> getFaveList() {
//   return favs;
// }

// Future<void> updateFavourite() {
//   return favourites
//       .doc('ABC123')
//       .set({
//         'docking_stations': null,
//       })
//       .then((value) => print("User Added"))
//       .catchError((error) => print("Failed to add user: $error"));
// }
//}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'docking_station_detail.dart';
import '../services/user_services.dart';

///Represents a station that has been favourited by the user
///
///
class FavouriteDockingStation {
  late String id;
  //late String uid;
  late String _stationId;
  //List<FavouriteDockingStation> favs = []; //just testing

  CollectionReference favourites =
      FirebaseFirestore.instance.collection('favourites');

  FavouriteDockingStation(this.id, this._stationId) {
    // uid = getUid();
    // addFavourite();
    // getUserFavourites();
    //print(_getFavoriteIDs);
  }

  FavouriteDockingStation.map(DocumentSnapshot document) {
    this.id = document.id;
    //this.uid = document.get('user_id');
    this._stationId = document.get('station_id');
  }

  Map toMap() {
    Map map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['station_id'] = stationId;
    //map['user_id'] = uid;
    return map;
  }

  String get stationId => _stationId;
}

// Future<void> addFavourite() {
//   // Call the user's CollectionReference to add a new user
//   return favourites
//       .add({
//         'user_id': uid, // John Doe
//         'station_id': stationId, // Stokes and Sons
//         'journeys': null // 42
//       })
//       .then((value) => print("fave Added"))
//       .catchError((error) => print("Failed to add fave: $error"));
// }

// Future<void> deleteFavourite(favid) {
//   return favourites
//       .doc(favid)
//       .delete()
//       .then((value) => print(" Deleted"))
//       .catchError((error) => print("Failed to delete fave: $error"));
// }

// Future<void> getUserFavourites() async {
//   List<FavouriteDockingStation> favs = [];

//   QuerySnapshot<Object?> docs =
//       await favourites.where('user_id', isEqualTo: uid).get();
//   if (docs != null) {
//     for (DocumentSnapshot doc in docs.docs) {
//       favs.add(FavouriteDockingStation.map(doc));
//     }
//   }

//   //print(favs[0].stationId);
// }

// Future<void> getUserFavourites() async {
//   var docs = favourites
//       .where('user_id', isEqualTo: uid)
//       .get()
//       .then((value) => print("got here"))
//       .catchError((error) => print("Failed to add user: $error"));
//   print(docs);

//   if (docs != null){
//     for (DocumentSnapshot doc in docs.documents){

//     }
//   }
// }

// Future<void> updateFavourite() {
//   return favourites
//       .doc('ABC123')
//       .set({
//         'docking_stations': null,
//       })
//       .then((value) => print("User Added"))
//       .catchError((error) => print("Failed to add user: $error"));
// }
