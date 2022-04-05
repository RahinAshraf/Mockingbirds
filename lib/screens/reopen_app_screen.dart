import 'package:flutter/material.dart';
import 'package:veloplan/styles/texts.dart';

/// Screen to inform user to close and reopen the app.
/// Author: Rahin
class reopenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/suggested_trips.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 18),
                Text(
                  "Please now close and reopen VeloPlan. When you come back, let's get exploring!",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.infoTextStyle,
                  key: Key('reopenAppText'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
