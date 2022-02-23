// // ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'docking2.dart';

class FavouriteDockingStation {
  late String uid;
  final String name;
  final String stationId; //id of the station
  final double lon;
  final double lat;

  FavouriteDockingStation(this.name, this.stationId, this.lon, this.lat) {
    getUid();
  }

  Future<void> getUid() async {
    uid = await setUid();
    // return uid;
  }

  Future<String> setUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    print(uid);
    return uid;
  }
}



  // Future<void> printUid() async {
  
  // }



  
// // class Favorite {
// //   String? username;
// //   String? id;
// // String? name;

// //   Favorite({this.id, this.username, this.name});

// //   Favorite.map(DocumentSnapshot document) {
// //     this.id = document.documentID;
// //     this.username = document.data['username'];
// // this.name = document.data['name'];
// //   }
// // }

// // class FavoriteData {
// //   List<Favorite> favorites;

// //   FavoriteData({required this.favorites});
// // }

// // class Favourite {
// //   String _id;
// //   String _eventId;
// //   String _userId;
// //   Favourite(this._id, this._eventId, this._userId);

// //   Favourite.map(DocumentSnapshot document) {
// //     this._id = document.documentID;
// //     this._eventId = document.data['eventId'];
// //     this._userId = document.data['userId'];
// //   }

// //   Map<String, dynamic> toMap() {
// //     Map map = Map<String, dynamic>();
// //     if (_id != null) {
// //       map['id'] = _id;
// //     }
// //     map['eventId'] = _eventId;
// //     map['userId'] = _userId;
// //     return map;
// //   }
// // }

// class ApplicationState extends ChangeNotifier {
//   // Current content of ApplicationState elided ...

//   // Add from here
//   Future<DocumentReference> addToFavouriteStations(String message) {
//     if (_loginState != ApplicationLoginState.loggedIn) {
//       throw Exception('Must be logged in');
//     }

//     return FirebaseFirestore.instance
//         .collection('favourites')
//         .add(<String, dynamic>{
//       //  'text': message,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'name': FirebaseAuth.instance.currentUser!.displayName,
//       'userId': FirebaseAuth.instance.currentUser!.uid,
//     });
//   }
//   // To here
// }
