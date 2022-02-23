import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import '/models/favourite.dart';
import '/services/favourite_service.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.

Widget dockingStationCard(
    int index, String name, String nb_bikes, String nb_empty_docks) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteButton(valueChanged: (_isFavorite) {
            handleLikedCard(name);
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

void handleLikedCard(name) {
  FavouriteDockingStation(name);
}
