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
    bubbles = Image.asset('assets/images/right_bubbles_shapes.png',
        width: 170, height: 170);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bubbles.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(alignment: Alignment.topRight, child: bubbles),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitDualRing(color: Color.fromARGB(255, 153, 210, 169)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
                  child: Text(
                    'Life is like riding a bicycle. In order to keep your balance you must keep moving.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 153, 210, 169)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
