import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyStatefulWidget());
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
            height: 190.0,
            width: 190.0,
            alignment: Alignment.topLeft,
            child: Image.asset('assets/images/bubbles-shapes.png')),
        Container(
            height: 190.0,
            width: 190.0,
            child:
                Center(child: Image.asset('assets/images/woman-cycling.png'))),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Cycle the city',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
            )),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Plan with us your journeys through London!',
              style: TextStyle(color: Colors.black, fontSize: 15),
            )),
        Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
              child:
                  const Text('Log in', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
        Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
              child:
                  const Text('Sign Up', style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/map');
          },
          child: const Text('Go to map!'),
        ),
      ],
    );
  }
}



// https://www.tutorialkart.com/flutter/flutter-login-screen/