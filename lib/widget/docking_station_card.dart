import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

///Card that holds information about a docking station.
Widget dockingStationCard(String word) {
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
                Text(
                  word,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


// Widget dockingStationCard(String name, int bikeNumber, int nb_empty_docks) {
//   return Card(
//     clipBehavior: Clip.antiAlias,
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage("https://picsum.photos/200/300"),
//             radius: 20,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
