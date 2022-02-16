import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';
import 'providers/counter_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Counter())],
    child: MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Login(), '/map': (context) => Navbar()},
    ),
  ));
}
