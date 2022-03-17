import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../styles/styling.dart';

class LocationPermissionError extends StatelessWidget {
  const LocationPermissionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('LogIn'),
        // ),
        body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pushNamed(context, '/map');
      //     },
      //     child: const Text('Go to map!'),
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.settings),
            onPressed: _openSettings,
            // padding: EdgeInsets.all(15.0),
            // child: CircularProgressIndicator(
            //     color: appBarColor, key: Key('LocationErrorSpanner')),
          ),
          Text("OPEN SETTINGS  \n "),
          Text(
            "Please enable location services for Veloplan... \n you cannot use Veloplan without it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
            key: Key('LocationPermissionErrorText'),
          ),
        ],
      ),
    ));
  }
}

void _openSettings() async {
  var locationStatus = await Permission.location.status;
  print(locationStatus);
  print("------");
  if (locationStatus.isGranted) {
    //CHANGE TO !, JUST USED GRANTED FOR TESTING PURPOSES -----
    openAppSettings();
  }
}

//AT THIS SCREEN --- CONTINUOUSLY CHECK STATUS - IF STATUS IS GRANTED THEN CONTINUE RUN APP
