import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

/// Creates a card for a docking station.
///
/// Displays [name] of docking station, total number of bikes in [nbBikes],
/// and how many docks are currently available in [nbEmptyDocks].
Widget dockingStationCard(
    int index, String name, String nbBikes, String nbEmptyDocks) {
  return Card(
    elevation: 1.0,
    color: const Color(0xFFF5F5F5),
    shadowColor: Colors.green[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FavoriteButton(valueChanged: (_isFavorite) {
            // TODO: make favorite button interactive
          }),
          const SizedBox(width: 10),
          Column(
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
              Text('Total number of bikes: $nbBikes'),
              Text('Available bikes: $nbEmptyDocks'),
            ],
          ),
        ],
      ),
    ),
  );
}
