import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/verify_email_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

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
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(), // _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'Veloplan',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xffffffff),
              primarySwatch: const MaterialColor(
                0xff99d2a9, // 0%
                const <int, Color>{
                  50: const Color(0xffa3d7b2), //10%
                  100: const Color(0xffaddbba), //20%
                  200: const Color(0xffb8e0c3), //30%
                  300: const Color(0xffc2e4cb), //40%
                  400: const Color(0xffcce9d4), //50%
                  500: const Color(0xffd6eddd), //60%
                  600: const Color(0xffe0f2e5), //70%
                  700: const Color(0xffebf6ee), //80%
                  800: const Color(0xfff5fbf6), //90%
                  900: const Color(0xffffff), //100%
                },
              ),
              buttonTheme: ButtonTheme.of(context).copyWith(
                // buttonColor: Colors.green,
                //textTheme: ButtonTextTheme.primary,
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
