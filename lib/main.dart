import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';

// void main() {
//   runApp(MaterialApp(
//     initialRoute: '/',
//     routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
//   ));
// }

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'demo');
//   }
// }

// class HomePage extends StatefulWidget { 
//   const MyHomePage 
// }
