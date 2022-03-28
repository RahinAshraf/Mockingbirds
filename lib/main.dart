
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/navbar.dart';
import 'package:veloplan/screens/auth_screen.dart';
import 'package:veloplan/screens/splash_screen.dart';
import 'package:veloplan/screens/verify_email_screen.dart';
import 'package:veloplan/styles/theme.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkPermissions();
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();
  liveLocationHelper.initializeLocation();
  sharedPreferences = await SharedPreferences.getInstance();
  MapModel _model = MapModel();
  runApp(ScopedModel<MapModel>(
      model: _model,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const MyApp(),
          '/map': (context) => NavBar()
        },
      )));
}

//APP IS ONLY WORKING WHEN "GRANTED" IS PRINTED OUT, FIX IT TO NOT CRASH AND REASK IN OTHER CASES
void checkPermissions() async {
  var locationStatus = await Permission.location.status;

  if (locationStatus.isGranted) {
    print("GRANTED");
  } else if (locationStatus.isDenied) {
    await Permission.location.request();
    print("ISDENIED HAPPENED");
  } else if (locationStatus.isPermanentlyDenied) {
    print("TELL USERS TO GO TO SETTINGS TO ALLOW LOCATION");
  } else if (locationStatus.isLimited) {
    print("ISLIMITED WAS SELECTED");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: Firebase.initializeApp(), // _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
            title: 'Veloplan',
            theme: CustomTheme.defaultTheme,
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
                    },
                  ));
      },
    );
  }
}
