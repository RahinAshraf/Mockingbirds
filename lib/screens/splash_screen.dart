import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image bubbles;
  //late Image logo;
  @override
  void initState() {
    super.initState();
    bubbles = Image.asset('assets/images/right_bubbles_shapes.png');
    //logo = Image.asset('assets/images/logo.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bubbles.image, context);
    //precacheImage(logo.image, context);
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
/* 
class RotatingLogo extends StatefulWidget {
  const RotatingLogo({Key? key}) : super(key: key);

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
} */

// class _RotatingLogoState extends State<RotatingLogo>
//     with TickerProviderStateMixin {
//   late AnimationController animationController;
//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     animationController = new AnimationController(
//       vsync: this,
//       duration: new Duration(milliseconds: 100),
//     );
//     animationController.repeat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//         alignment: Alignment.center,
//         color: Colors.white,
//         child: RotationTransition(
//             child: Icon(Icons.refresh), turns: animationController));
//   }
//   @override
//   void initState() {
//     super.initState();
//     animationController = new AnimationController(
//       vsync: this,
//       duration: new Duration(milliseconds: 5000),
//     );
//     animationController.forward();
//     animationController.addListener(() {
//       setState(() {
//         if (animationController.status == AnimationStatus.completed) {
//           animationController.repeat();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       alignment: Alignment.center,
//       color: Colors.white,
//       child: new AnimatedBuilder(
//         animation: animationController,
//         child: new Container(
//           height: 80.0,
//           width: 80.0,
//           child: new Image.asset('assets/images/logo.png'),
//         ),
//         builder: (_, child) {
//           return new Transform.rotate(
//             angle: animationController.value,
//             child: child,
//           );
//         },
//       ),
//     );
//   }
// }

