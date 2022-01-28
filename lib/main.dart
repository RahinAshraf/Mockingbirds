// import 'dart:js';

import 'package:flutter/material.dart';
import 'screens/map.dart';
import 'screens/login.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => MapPage()},
  ));
}
