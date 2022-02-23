// // ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'docking2.dart';
import '../services/user_services.dart';

///Adds a station to current users favourite
///
class FavouriteDockingStation {
  late String uid;
  final String stationId; //id of the station

  CollectionReference favourites =
      FirebaseFirestore.instance.collection('favourites');

  FavouriteDockingStation(this.stationId) {
    uid = getUid();
    addFavourite();
  }

  Future<void> addFavourite() {
    // Call the user's CollectionReference to add a new user
    return favourites
        .add({
          'user': getUid(), // John Doe
          'docking_stations': null, // Stokes and Sons
          'journeys': null // 42
        })
        .then((value) => print("fave Added"))
        .catchError((error) => print("Failed to add fave: $error"));
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
}
