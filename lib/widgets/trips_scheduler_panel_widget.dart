import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/styles/styling.dart';

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
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  late String formattedDate;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
            child: Text(
              'Please fill in the following details of your trip.',
              style: infoTextStyle,
            ),
          ),
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
          const SizedBox(
            height: 24,
          ),
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
                  onPressed: () async {
                    final response = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JourneyPlanner(
                                  numberOfCyclists: numberOfCyclists,
                                  journeyDate: DateTime.now(),
                                )));
                    if (response) {
                      Navigator.of(context).pop(true);
                    }
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
          Padding(
            // TODO: do something with the time value rather than just displaying it.
            // TODO: check if there is no journey planned for the same day. [OPTIONAL]

            padding: const EdgeInsets.only(top: 24.0),
            child: Center(child: Text(formatter.format(selectedDate))),
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
        navigate();
      });
    }
  }

  void navigate() async {
    final response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JourneyPlanner(
                  numberOfCyclists: numberOfCyclists,
                  journeyDate: selectedDate,
                  isScheduled: true,
                )));
    if (response) {
      Navigator.of(context).pop(true);
    }
  }
}
