import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:veloplan/helpers/database_helpers/schedule_helper.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/widgets/upcoming_event_card.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var helper = ScheduleHelper();
  late List<Itinerary> upcomingJourneys = [];
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  initState() {
    helper.getAllScheduleDocuments().then((data) {
      setState(() {
        upcomingJourneys = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteReplacement,
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TableCalendar(
              calendarStyle: scheduleScreenCalendarStyle,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
              lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month,
                  DateTime.now().day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                  });
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Upcoming journeys', style: upcomingJourneysTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                for (var journey in upcomingJourneys)
                  UpcomingEventCard(
                    event: journey,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
