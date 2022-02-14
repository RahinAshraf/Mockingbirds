import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
        appBar: AppBar(
          title: const Text('LogIn'),
        ),
        body: MyStatefulWidget());
=======
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
>>>>>>> Stashed changes
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
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
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
                height: 75,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ElevatedButton(
                  child: const Text('Log In'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )),
            Container(
                height: 75,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )),
          ],
        ));
  }
}

// https://www.tutorialkart.com/flutter/flutter-login-screen/