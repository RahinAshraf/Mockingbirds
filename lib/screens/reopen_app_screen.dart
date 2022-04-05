import 'package:flutter/material.dart';

///Screen to inform user to close and reopen the app
///Author: Rahin

class reopenApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width:MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //ADD ASSET TO MAKE IT LOOK NICER
            Text(
              "Please now close and reopen VeloPlan. When you come back, let's get exploring!",
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
              key: Key('reopenAppText'),
            ),
          ],
        ),
      ),
    );
  }

}
