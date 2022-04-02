import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/utilities/permissions.dart';
import 'package:veloplan/widgets/locationPermissionError.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();
  liveLocationHelper.initializeLocation();
  sharedPreferences = await SharedPreferences.getInstance();
  MapModel _model = MapModel();
  runApp(ScopedModel<MapModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const MyApp(),
          '/map': (context) => NavBar()
        },
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Permission permission;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  Future<void> requestForPermission() async {
    final status = await Permission.location.request();
    setState(() {
      permissionStatus = status;
    });
  }

  void requestPermission() {
    if (mounted) {
      PermissionUtils.instance.getLocation(context).listen((status) {
        if (status == Permissions.DENY) {
          context.pushAndRemoveUntil(LocationError());
        } else if (status == Permissions.ASK_EVERYTIME) {
          // Show permission
          requestPermission();
        }
      });
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 10), () {
      requestPermission();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: Firebase.initializeApp(), // _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
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
