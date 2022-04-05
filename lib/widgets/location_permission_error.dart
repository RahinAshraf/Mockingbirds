import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veloplan/screens/reopen_app_screen.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/styles/theme.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/utilities/enums/location_enums.dart';
import 'package:veloplan/utilities/permissions.dart';

/// Widget to display a location permissions error.
///
/// Builds a widget displaying a circular progression indicator and an error message
/// for when the live location is not enabled.
/// Author: Rahin Ashraf
/// Contributor: Marija
class LocationError extends StatefulWidget {
  @override
  LocationErrorState createState() {
    return LocationErrorState();
  }
}

class LocationErrorState extends State<LocationError>
    with WidgetsBindingObserver {
  LocationErrorState() {}

  /// Opens user's settings app.
  void _goToSettings() async {
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
    return Theme(
      data: CustomTheme.defaultTheme,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/suggested_trips.png',
                    width: 170,
                    height: 170,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Please enable your location permission access in order to use VeloPlan."
                      "\n After enabling your locations permissions, please close and reopen the app to begin your visit in London!",
                      style: CustomTextStyles.infoTextStyle,
                      textAlign: TextAlign.center,
                      key: Key('LocationErrorText'),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: _goToSettings,
                    child: Text(
                      "ENABLE",
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/right_bubbles_shapes.png',
                  width: 170,
                  height: 170,
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
    super.dispose();
  }
}
