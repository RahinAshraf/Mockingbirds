import 'package:flutter/material.dart';
import '../styles/styling.dart';

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
        title: const Text('Settings'),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Text("Settings page!"),
      ),
    );
  }
}
//check for push 