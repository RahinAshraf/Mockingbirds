import 'package:flutter/material.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/styles/texts.dart';

class TripSchedulerPanelWidget extends StatefulWidget {
  @override
  _TripSchedulerPanelWidget createState() => _TripSchedulerPanelWidget();
}

/// Renders a panel widget used in [TripSchedulerScreen].
///
/// A user is asked to input [numberOfCyclists], which is limited to
/// [maximumNumberOfCyclists] due to live docking station constraints.
///
/// It also asks whether the user wants to schedule trip immediately
/// (in that case, the user is directed straight to the [JourneyPlanner]),
/// or later (a date picker shows up and a trip is scheduled
/// for the future).
/// Authors: Rahin, Marija
class _TripSchedulerPanelWidget extends State<TripSchedulerPanelWidget> {
  final int maximumNumberOfCyclists = 6; // max number of cyclists allowed
  int numberOfCyclists = 1;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Please fill in the following details of your trip.',
            style: CustomTextStyles.infoTextStyle,
          ),
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 24,
                child: Text("Number of cyclists in the group:",
                    style: CustomTextStyles.tripSchedulerTextStyle),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _decrementCounter,
                icon: const Icon(Icons.remove_rounded, color: Colors.black),
              ),
              const Spacer(),
              Text('$numberOfCyclists',
                  style: CustomTextStyles.cyclistNumberTextStyle),
              const Spacer(),
              IconButton(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add_rounded, color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 2) - 24,
                child: Text(
                  "When would you like to cycle?",
                  style: CustomTextStyles.tripSchedulerTextStyle,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                key: Key("now"),
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () async {
                    _navigate(DateTime.now(), false);
                  },
                  child: const Text('Now'),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Flexible(
                key: Key("later"),
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

  /// Increments [numberOfCyclists] by one if doing so does not break any constraints.
  void _incrementCounter() {
    setState(() {
      if (numberOfCyclists < maximumNumberOfCyclists) {
        numberOfCyclists++;
      }
    });
  }

  /// Decrements [numberOfCyclists] by one if doing so does not break any constraints.
  void _decrementCounter() {
    setState(() {
      if (numberOfCyclists > 1) {
        numberOfCyclists--;
      }
    });
  }

  /// Displays date picker and saves user's choice in [selectedDate].
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // users cannot plan a journey for past date
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
      errorInvalidText: "Select future date no more than a year ahead.",
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _navigate(selectedDate, true);
      });
    }
  }

  /// Handles the click 'Now' and 'Later' button clicks.
  void _navigate(DateTime date, bool isScheduled) async {
    final response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JourneyPlanner(
                  numberOfCyclists: numberOfCyclists,
                  journeyDate: date,
                  isScheduled: isScheduled,
                )));
    if (response) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
    }
  }
}
