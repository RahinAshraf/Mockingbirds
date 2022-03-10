import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../helpers/live_location_helper.dart';
import '../navbar.dart';
import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/verify_email_screen.dart';
import '../styles/styling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LiveLocationHelper liveLocationHelper = LiveLocationHelper();
  liveLocationHelper.initializeLocation();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => const MyApp(), '/map': (context) => Navbar()},
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
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(

        // Initialize FlutterFire:

        future: Firebase.initializeApp(), // _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Veloplan',
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: appBarColor,
                foregroundColor: appBarTextColor,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.green[200],
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey[10],
              ),
              dialogTheme: const DialogTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                titleTextStyle: popupDialogTitleTextStyle,
                contentTextStyle: popupDialogTextStyle,
              ),
              scaffoldBackgroundColor: const Color(0xffffffff),
              primarySwatch: const MaterialColor(
                0xff99d2a9, // 0%
                <int, Color>{
                  50: Color(0xffa3d7b2), //10%
                  100: Color(0xffaddbba), //20%
                  200: Color(0xffb8e0c3), //30%
                  300: Color(0xffc2e4cb), //40%
                  400: Color(0xffcce9d4), //50%
                  500: Color(0xffd6eddd), //60%
                  600: Color(0xffe0f2e5), //70%
                  700: Color(0xffebf6ee), //80%
                  800: Color(0xfff5fbf6), //90%
                  900: Color(0xffffffff), //100%
                },
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
