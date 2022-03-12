// import 'package:flutter/material.dart';

// class MapItemDetailsScreen extends StatelessWidget {
//   const MapItemDetailsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final _styleNameDockingStation = TextStyle(
//         color: Color(0xFF99D2A9), fontSize: 18, fontWeight: FontWeight.bold);
//     final _styleDistanceToDockingStation = TextStyle(
//         color: Color(0xFF99D2A9), fontSize: 14, fontWeight: FontWeight.bold);

//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Card(
//         margin: EdgeInsets.zero,
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(child: Image.asset('assets/images/logo.png')),
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Name of dock station:',
//                             style: _styleNameDockingStation),
//                         Text('Distance to this dock station:',
//                             style: _styleDistanceToDockingStation)
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
