import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/utilities/enums/location_enums.dart';
import 'package:veloplan/utilities/permissions.dart';
import '../screens/reopen_app_screen.dart';

///Widget to display a Location error
///Author: Rahin Ashraf k20034059

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

  /// Opens user's setting app
  void goToSettings() async {
    await openAppSettings();
  }

  /// Listens to the [permissionStatus] of the user's live location
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted && state == AppLifecycleState.resumed) {
      PermissionUtils.instance.getLocation(context).listen((status) {
        if (status == Permissions.ALLOW_WHILE_USING_APP ||
            status == Permissions.ALLOW_ALL_TIME) {
          FirebaseAuth.instance.signOut();
          context.pushAndRemoveUntil(reopenApp());
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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
            Text(
              "Please enable your location permissions access in order to use VeloPlan. \n After "
              "enabling your locations permissions, please reopen the app to begin your visit \n"
              "London!",
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
              key: Key('LocationErrorText'),
            ),
            ElevatedButton(
              onPressed: goToSettings,
              child: Text(
                "ENABLE",
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
