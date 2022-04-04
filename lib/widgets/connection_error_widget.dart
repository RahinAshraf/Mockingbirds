import 'package:flutter/material.dart';

/// Widget to display a connection error
/// Author(s): Fariha Choudhury k20059723, Hristina-Andreea Sararu k20036771

/// Builds a widget displaying a cirucular progression indicator and error message
/// for when no internet connection is established.
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
                child: CircularProgressIndicator(color: Color(0xFF99D2A9)),
              ),
            ),
            SizedBox(height: 20),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Ooops!",
                  style: TextStyle(
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),
            SizedBox(height: 20),
            Text(
              "No Internet Connection Found!  \n \n Please check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF99D2A9),
                fontSize: 16,
              ),
            ),
          ],
        )));
  }
}
