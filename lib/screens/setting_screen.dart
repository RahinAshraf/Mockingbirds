import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

class Settings extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Settings'),
  //     ),
  //     body: Center(
  //       child: Text("Settings page!"),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("Page 2"),
          backgroundColor: Colors.transparent,
          elevation: 0.0),
      body: ScopedModelDescendant<NavigationModel>(builder:
          (BuildContext context, Widget? child, NavigationModel model) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your counter value is: ${model.count}',
                style: TextStyle(fontSize: 18.0),
              ),
              // RaisedButton(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text('Confirm'),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute<Page3>(
              //             builder: (BuildContext context) => Page3()),
              //       );
              //     })
            ],
          ),
        );
      }),
    );
  }
}
//check for push 