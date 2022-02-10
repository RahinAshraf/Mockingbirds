import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '.env.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
  ));
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'flutter demo',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext build) {
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           center: latLng.LatLng(51.5, -0.09),
//           zoom: 13.0,
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate:
//                 "https://api.mapbox.com/styles/v1/mockingbirds/ckzh4k81i000n16lcev9vknm5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNremd3NW9weDM2ZmEybm45dzlhYzN0ZnUifQ.lSzpNOhK2CH9-PODR0ojLg",
//             additionalOptions: {
//               'accessToken': MAPBOX_ACCESS_TOKEN,
//               'id': 'mapbox.mapbox-streets-v8'
//             },
//             attributionBuilder: (_) {
//               return Text("VeloPlan");
//             },
//           ),
//           MarkerLayerOptions(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: latLng.LatLng(51.5, -0.09),
//                 builder: (ctx) => Container(
//                   child: FlutterLogo(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
