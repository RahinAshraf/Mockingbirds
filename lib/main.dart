import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/map_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Veloplan',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
            ).copyWith(
              secondary: Colors.black,
            ),
          ),
          //home: const MyHomePage(title: 'Topper'),
          initialRoute: '/auth',
          routes: {
            '/': (ctx) => MapPage(),
            '/auth' : (ctx) => const AuthScreen(),
          },
          onGenerateRoute: (settings) {
            //print(settings.arguments);
            return MaterialPageRoute(builder: (ctx) => AuthScreen());
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => AuthScreen());
          },
        );
  }
}