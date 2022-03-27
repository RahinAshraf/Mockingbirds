import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veloplan/screens/auth_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/utilities/permissions.dart';
import '../styles/theme.dart';

///Widget to display a Location error
///@author: Rahin Ashraf k20034059

/// Builds a widget displaying a circular progression indicator and an error message
/// for when the live location is not enabled.
class LocationError extends StatefulWidget {
  @override
  LocationErrorState createState() {
    return LocationErrorState();
  }
}

class LocationErrorState extends State<LocationError>
    with WidgetsBindingObserver {
  LocationErrorState() {}

  void goToSettings() async {
    await openAppSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("BuildContextrrr_isGranted => $state");
    if (mounted && state == AppLifecycleState.resumed) {
      PermissionUtils.instance.getLocation(context).listen((status) {
        if (status == Permissions.ALLOW_WHILE_USING_APP ||
            status == Permissions.ALLOW_ALL_TIME) {
          FirebaseAuth.instance.signOut();
          context.pushAndRemoveUntil(AuthScreen());
        } else {
          print("Permission is $status");
        }
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("BuildContext => $context");
    return MaterialApp(
      theme: CustomTheme.defaultTheme,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/right_bubbles_shapes.png',
                  width: 170,
                  height: 170,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bicycle_location.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Please enable your location permission access in order to use VeloPlan."
                      "\n After enabling your locations permissions, please close and reopen the app to begin your visit in London!",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      key: Key('LocationErrorText'),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    ElevatedButton(
                      onPressed: goToSettings,
                      child: Text(
                        "ENABLE",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    //PermissionUtils.instance.dispose();
    super.dispose();
  }
}
