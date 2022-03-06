import 'package:flutter/material.dart';
import '../styles/styling.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: appBarColor,
        // width: MediaQuery.of(context).size.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/connection_error.png",
              height: 75,
              width: 75,
            ),
            const Text(
              "Connection error, please check your internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color:Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}