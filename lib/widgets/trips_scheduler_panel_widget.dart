import 'package:flutter/material.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/styles/styling.dart';

class TripSchedulerPanelWidget extends StatefulWidget {
  @override
  _TripSchedulerPanelWidget createState() => _TripSchedulerPanelWidget();
}

/// Renders a panel widget used in [TripSchedulerScreen].
///
/// A user is asked to input [numberOfCyclists], which is limited to
/// [maximumNumberOfCyclists] due to the docking station constraints.
///
/// It also asks whether the user wants to schedule trip immediately
/// (in that case, the user is directed directly to the [JourneyPlanner]),
/// or later (a date picker shows up and a trip is scheduled
/// for the future).
class _TripSchedulerPanelWidget extends State<TripSchedulerPanelWidget> {
  final int maximumNumberOfCyclists = 6; // max number of cyclists allowed
  int numberOfCyclists = 1; // min one cyclist allowed
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Text(
            'Please fill in the following details of your trip.',
            style: infoTextStyle,
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 24,
                child: const Text("Number of cyclists in the group:",
                    style: tripSchedulerTextStyle),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _decrementCounter,
                icon: const Icon(
                  Icons.remove_rounded,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                '$numberOfCyclists',
                style: cyclistNumberTextStyle,
              ),
              const Spacer(),
              IconButton(
                onPressed: _incrementCounter,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 24,
                child: const Text(
                  "When would you like to cycle?",
                  style: tripSchedulerTextStyle,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JourneyPlanner(
                                numberOfCyclists: numberOfCyclists)));
                  },
                  child: const Text('Now'),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Later'),
                ),
              ),
            ],
          ),
        ],
      );

  void _incrementCounter() {
    setState(() {
      if (numberOfCyclists < maximumNumberOfCyclists) {
        numberOfCyclists++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (numberOfCyclists > 1) {
        numberOfCyclists--;
      }
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // users cannot plan a journey for past date
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
          DateTime.now().day + 1),
      errorInvalidText: "Select future date no more than a year ahead.",
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
