import 'package:flutter/material.dart';
import '../screens/journey_planner_screen.dart';

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
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0); // DON'T add const

  ButtonStyle journeyTimeButtonStyle = TextButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.green[500],
      primary: Colors.white);

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
      errorInvalidText:
          "You cannot plan a journey for past date or more than one year ahead.",
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

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 36,
          ),
          fillInInfoText(),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Number of cyclists:",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              const SizedBox(
                width: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundIncDecButton(
                      tag: "DecBtn",
                      onPressed: _decrementCounter,
                      icon: Icons.remove_rounded,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('$numberOfCyclists',
                          style: const TextStyle(fontSize: 30.0)),
                    ),
                    RoundIncDecButton(
                      tag: "IncBtn",
                      onPressed: _incrementCounter,
                      icon: Icons.add_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const SizedBox(
                width: 180,
                child: Text(
                  "When would you like to cycle?",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ),
              const SizedBox(
                width: 15,
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
          // TODO: check if there is no journey planned for the same day. [OPTIONAL]
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
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            )
          ],
        ),
      );
}

class RoundIncDecButton extends StatelessWidget {
  const RoundIncDecButton(
      {required this.tag, required this.onPressed, required this.icon});

  final Object tag;
  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: tag,
      onPressed: onPressed,
      elevation: 3.0,
      mini: true,
      child: Icon(
        icon,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    );
  }
}
