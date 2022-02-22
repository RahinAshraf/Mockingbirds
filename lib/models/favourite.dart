// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// class Favorite {
//   String? username;
//   String? id;

//   Favorite({this.id, this.username});

//   Favorite.map(DocumentSnapshot document) {
//     this.id = document.documentID;
//     this.username = document.data['username'];
//   }
// }

// class FavoriteData {
//   List<Favorite> favorites;

//   FavoriteData({required this.favorites});
// }

// class Favourite {
//   String _id;
//   String _eventId;
//   String _userId;
//   Favourite(this._id, this._eventId, this._userId);

//   Favourite.map(DocumentSnapshot document) {
//     this._id = document.documentID;
//     this._eventId = document.data['eventId'];
//     this._userId = document.data['userId'];
//   }

//   Map<String, dynamic> toMap() {
//     Map map = Map<String, dynamic>();
//     if (_id != null) {
//       map['id'] = _id;
//     }
//     map['eventId'] = _eventId;
//     map['userId'] = _userId;
//     return map;
//   }
// }
