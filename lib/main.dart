import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
  ));
}
