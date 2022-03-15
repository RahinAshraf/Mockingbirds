import 'package:flutter/material.dart';
import '../styles/styling.dart';

/// Widget to display a connection error
/// Author(s): Fariha Choudhury k20059723

/// Builds a widget displaying a cirucular progression indicator and error message
/// for when no internet connection is established.
class ConnectionError extends StatelessWidget {
  const ConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(
                color: appBarColor, key: Key('internetErrorSpanner')),
          ),
          Text(
            "Reconnecting... \n please check your internet connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
            key: Key('internetErrorText'),
          ),
        ],
      ),
    ));
  }
}
