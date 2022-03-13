import 'package:flutter/material.dart';
import '../screens/journey_planner_screen.dart';
import '../styles/styling.dart';

class PanelWidgetTripScheduler extends StatefulWidget {
  const PanelWidgetTripScheduler({required ScrollController controller});

  @override
  _PanelWidgetTripScheduler createState() => _PanelWidgetTripScheduler();
}

class _PanelWidgetTripScheduler extends State<PanelWidgetTripScheduler> {
  ScrollController controller = ScrollController();

  final int maximumNumberOfCyclists = 6; // there can be <=6 people in the group
  int numberOfCyclists = 1; // min one cyclist allowed
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 36, bottom: 24),
            child: fillInInfoText(),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Number of cyclists:",
                  style: tripSchedulerTextStyle,
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: _decrementCounter,
                    icon: const Icon(
                      Icons.remove_rounded,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      '$numberOfCyclists',
                      style: cyclistNumberTextStyle,
                    ),
                  ),
                  IconButton(
                    onPressed: _incrementCounter,
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  width: 180,
                  child: Text(
                    "When would you like to cycle?",
                    style: tripSchedulerTextStyle,
                  ),
                ),
              ),
              TextButton(
                style: journeyTimeButtonStyle,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JourneyPlanner()));
                },
                child: const Text('Now'),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                style: journeyTimeButtonStyle,
                onPressed: () => _selectDate(context),
                child: const Text('Later'),
              ),
            ],
          ),
          // TODO: do something with the time value rather than just displaying it.
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(child: Text(selectedDate.toString())),
          ),
        ],
      );

  Widget fillInInfoText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Please fill in the following details of your trip.",
              style: infoTextStyle,
            )
          ],
        ),
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
      if (numberOfCyclists != 1) {
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
      errorInvalidText: "Please select future date no more than a year ahead.",
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, picked.hour, picked.minute);
      });
    }
  }
}
