import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image bubbles;

  @override
  void initState() {
    super.initState();
    bubbles = Image.asset('assets/images/right_bubbles_shapes.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bubbles.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            (Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          height: 190.0,
          width: 190.0,
          alignment: Alignment.topRight,
          child: bubbles),
      SizedBox(height: 50),
      SpinKitDualRing(color: Color.fromARGB(255, 153, 210, 169)),
      SizedBox(height: 50),
      Text(
        'Life is like riding a bicycle. In order to keep your balance you must keep moving. ',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 15, color: Color.fromARGB(255, 153, 210, 169)),
      ),
      SizedBox(height: 20),
    ])));
  }
}
