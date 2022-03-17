import 'package:flutter/material.dart';
import '../styles/styling.dart';
import '../helpers/history_helper.dart';

class Schedule extends StatelessWidget {
  HistoryHelper helper = new HistoryHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: appBarColor,
      ),
      // body: Center(
      //   child: FloatingActionButton(onPressed: () {
      //     helper.addDockingStation("second", "name", "journey1");
      //   }),
      // ),
    );
  }
}
