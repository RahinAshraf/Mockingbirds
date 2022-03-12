import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/verify_email_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();
  liveLocationHelper.initializeLocation();
  //checkPermissions();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => const MyApp(), '/map': (context) => Navbar()},
  ));
}

// void checkPermissions() async {
//   var locationStatus = await Permission.location.status;
//
//   if(locationStatus.isGranted){
//     print("GRANTED");
//   }
//   else if(locationStatus.isDenied){
//     await Permission.location.request();
//     print("ISDENIED HAPPENED");
//   }
//   else if(locationStatus.isPermanentlyDenied){
//     print("TELL USERS TO GO TO SETTINGS TO ALLOW LOCATION");
//   }
//   else if(locationStatus.isLimited){
//     print("ISLIMITED WAS SELECTED");
//   }
// }

// void main() {
//   runApp(MultiProvider(providers: [], child: const MyApp()));
// }

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
