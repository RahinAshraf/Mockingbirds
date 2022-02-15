import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

Widget dockingStationCard(
    int index, String name, String nb_bikes, String nb_empty_docks) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteButton(valueChanged: (_isFavorite) {}),
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
