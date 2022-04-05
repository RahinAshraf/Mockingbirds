import 'package:flutter/material.dart';
import 'package:veloplan/styles/texts.dart';

/// Screen to inform user to close and reopen the app.
/// Author: Rahin
/// Contributor: Marija
class reopenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Please now close and reopen VeloPlan. When you come back, let's get exploring!",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.infoTextStyle,
                    key: Key('reopenAppText'),
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
    );
  }
}
