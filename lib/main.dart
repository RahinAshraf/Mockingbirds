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
