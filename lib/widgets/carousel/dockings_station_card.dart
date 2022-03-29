import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
Widget dockingsStationCard(
    int index, String name, String nb_bikes, String nb_empty_docks) {
  return Card(
    elevation: 1.0,
    shadowColor: Colors.green[200],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    clipBehavior: Clip.antiAlias,
    child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'Station 1',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 150),
                FavoriteButton(valueChanged: (_isFavorite) {}),
              ],
            ),
            const Divider(
              color: Color(0xFF99D2A9),
              thickness: 5,
            ),
            Row(children: const [
              SizedBox(width: 30.0),
              Icon(
                Icons.event_available,
                color: Color(0xFF99D2A9),
                size: 15.0,
              ),
              Text(
                " Free spaces:       17",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF99D2A9),
                ),
              ),
            ]),
            Row(
              children: const [
                SizedBox(width: 30.0),
                ImageIcon(
                  AssetImage("assets/images/logo.png"),
                  color: Color(0xFF99D2A9),
                  size: 15,
                ),
                Text(
                  " Free cycles:        20",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF99D2A9),
                  ),
                ),
              ],
            ),
          ],
        )),
  );
}
