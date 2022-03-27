import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloplan/providers/connectivity_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/verify_email_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import 'utilities/connectivity_status_enums.dart';
import '../widgets/connection_error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veloplan/helpers/live_location_helper.dart';
import 'package:veloplan/helpers/theme_provider.dart';
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
  runApp(
    ChangeNotifierProvider(
        create: (context) => ConnectivityProvider(),
        child: Consumer<ConnectivityProvider>(
            builder: (context, connectivityProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: connectivityProvider.connectionStatus !=
                      ConnectivityStatus.Offline
                  ? ScopedModel<MapModel>(
                      model: _model,
                      child: MaterialApp(
                        initialRoute: '/',
                        routes: {
                          '/': (context) => const MyApp(),
                          '/map': (context) => NavBar()
                        },
                      ))
                  : const ConnectionError());
        })),
  );
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
    // currentTheme.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(), // _initialization,
        builder: (context, appSnapshot) {
          return ChangeNotifierProvider(
              create: (_) => ThemeNotifier(),
              child: Consumer<ThemeNotifier>(
                builder: (context, ThemeNotifier notifier, child) {
                  return MaterialApp(
                    title: 'Veloplan',
                    theme: notifier.isDarkTheme
                        ? CustomTheme.darkTheme
                        : CustomTheme.defaultTheme,
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
                          ),
                  );
                },
              ));
        });
  }
}
