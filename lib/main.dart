import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:veloplan/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/verify_email_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  initializeLocation(); //Upon opening the app, store the users current location
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => const MyApp(), '/map': (context) => Navbar()},
  ));
}

void initializeLocation() async {
  Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
  }

  LocationData _locationData = await _location.getLocation();
  LatLng currentLatLng =
      LatLng(_locationData.latitude!, _locationData.longitude!);

  saveLocation(_locationData);
}

void saveLocation(LocationData _locationData) {
  sharedPreferences.setDouble('latitude', _locationData.latitude!);
  sharedPreferences.setDouble('longitude', _locationData.longitude!);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(), // _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Veloplan',
            theme: ThemeData(
              primarySwatch: Colors.green,
              backgroundColor: Colors.white,
              accentColor: Colors.amber,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? const SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return const VerifyEmailScreen();
                      }
                      return const AuthScreen();
                    }),
          );
        });
  }
}
