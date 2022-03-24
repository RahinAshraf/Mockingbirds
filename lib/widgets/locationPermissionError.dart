import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veloplan/main.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/utilities/permissions.dart';
import 'package:veloplan/widgets/auth/auth_form.dart';

import '../screens/auth_screen.dart';
import '../screens/splash_screen.dart';

///Widget to display a Location error
///@author: Rahin Ashraf k20034059

/// Builds a widget displaying a circular progression indicator and an error message
/// for when the live location is not enabled.
class LocationError extends StatefulWidget{

  @override
  LocationErrorState createState() {
    return LocationErrorState();
  }

}

class LocationErrorState extends State<LocationError> with WidgetsBindingObserver{

  LocationErrorState(){

  }

  void enable() async{
    await openAppSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("BuildContextrrr_isGranted => $state");
    if(mounted && state == AppLifecycleState.resumed){
      PermissionUtils.instance.getLocation(context).listen((status) {
        if(status == Permissions.ALLOW_WHILE_USING_APP || status == Permissions.ALLOW_ALL_TIME){
           context.pushAndRemoveUntil(SplashScreen());

        }else {
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
      home: Center(
        child: Container(
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
                "Please enable your location permission access in order to use VeloPlan.",
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
                key: Key('LocationErrorText'),
              ),
              ElevatedButton(
                onPressed: enable,
                child: Text(
                  "ENABLE",
                  textDirection: TextDirection.ltr,
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
