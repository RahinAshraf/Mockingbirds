import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => MapPage()},
  ));
}
