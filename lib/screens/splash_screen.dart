import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        Container(
            height: 190.0,
            width: 190.0,
            alignment: Alignment.topRight,
            child: Image.asset('assets/images/right_bubbles_shapes.png')),
        Text(
          'Loading...',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30, color: Color.fromARGB(255, 153, 210, 169)),
        ),
      ]),
    ));
  }
}
