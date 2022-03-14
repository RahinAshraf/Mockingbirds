import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/splash_screen.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'screens/auth_screen.dart';
import 'screens/verify_email_screen.dart';
import 'styles/theme.dart';
import 'styles/config.dart';
import '../helpers/live_location_helper.dart';
import '../navbar.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();
  liveLocationHelper.initializeLocation();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => const MyApp(), '/map': (context) => NavBar()},
  ));
}

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
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
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
