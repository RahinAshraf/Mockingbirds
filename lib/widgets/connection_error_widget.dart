import 'package:flutter/material.dart';
import 'package:veloplan/styles/colors.dart';

/// Widget to display a connection error
///
/// Builds a widget displaying a circular progression indicator and error message
/// for when no internet connection is established.
/// Author(s): Fariha Choudhury , Hristina-Andreea Sararu
class ConnectionError extends StatelessWidget {
  const ConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: (Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 170.0,
                width: 170.0,
                alignment: Alignment.topRight,
                child: Image.asset('assets/images/right_bubbles_shapes.png')),
            Container(
                height: 170.0,
                width: 170.0,
                child: Center(
                    child: Image.asset('assets/images/no_connection.png'))),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: CircularProgressIndicator(color: CustomColors.green),
              ),
            ),
            SizedBox(height: 20),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Ooops!",
                  style: TextStyle(
                      color: CustomColors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),
            SizedBox(height: 20),
            Text(
              "No Internet Connection Found!  \n \n Please check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.green,
                fontSize: 16,
              ),
            ),
          ],
        )));
  }
}
