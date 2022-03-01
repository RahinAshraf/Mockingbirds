import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.

Widget dockingStationCard(
    int index, String name, String nb_bikes, String nb_empty_docks) {
  return Card(
    elevation: 1.0,
    shadowColor: Colors.green[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FavoriteButton(valueChanged: (_isFavorite) {}),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Text('Total number of bikes: $nb_bikes'),
                Text('Available bikes: $nb_empty_docks'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
