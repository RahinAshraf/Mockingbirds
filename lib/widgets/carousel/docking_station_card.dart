import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import '/models/favourite.dart';
import '/services/favourite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:veloplan/models/docking_station.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
FirestoreHelper helper = FirestoreHelper();

Widget dockingStationCard(int index, DockingStation station, String id,
    String name, String nb_bikes, String nb_empty_docks) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteButton(valueChanged: (_isFavorite) {
            //handleLikedCard(id);
            helper.toggleFavourite(station);
          }),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text('Bike no: $nb_bikes'),
                Text('Empty: $nb_empty_docks'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// void handleLikedCard(id) {
//   // FavouriteDockingStation(id);
//   //print(id);
// }

// FirestoreHelper helper = FirestoreHelper();

// void toggleFavourite(DockingStation station) {
//   helper.addFavourite(station.id);
// }
