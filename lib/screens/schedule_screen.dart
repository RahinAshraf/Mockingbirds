import 'package:flutter/material.dart';
import '../utilities/styling.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Text("schedule page!"),
      ),
    );
  }
}
