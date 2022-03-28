import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:veloplan/helpers/schedule_helper.dart';
import 'package:veloplan/models/journey.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/widgets/upcoming_event_card.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var helper = ScheduleHelper();
  late CalendarFormat _calendarFormat;

  /// All the upcoming journeys.
  List<Journey> upcomingJourneys = [];

  /// Journeys, but mapped to the date.
  late Map<DateTime, List<Journey>> _events;

  /// Events on a selected day.
  late List _selectedEvents;
  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    helper.getAllScheduleDocuments().then((data) {
      setState(() {
        upcomingJourneys = data;
        upcomingJourneys.sort((a, b) {
          return a.date!.compareTo(b.date!);
        });
        _events = _groupByDate(upcomingJourneys);
        _selectedEvents = _events[_selectedDay] ?? [];
        _calendarFormat = CalendarFormat.twoWeeks;
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
              eventLoader: _getEventsForDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateTime.now(),
              lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month,
                  DateTime.now().day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarStyle: scheduleScreenCalendarStyle,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                    _selectedEvents = _getEventsForDay(selectedDay);
                  });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Upcoming journeys', style: upcomingJourneysTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                for (var event in _selectedEvents)
                  UpcomingEventCard(journey: event),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Groups [journeys] based on their date.
  Map<DateTime, List<Journey>> _groupByDate(List<Journey> journeys) {
    Map<DateTime, List<Journey>> mappedJourneys = {};
    for (Journey journey in upcomingJourneys) {
      mappedJourneys.putIfAbsent(
          journey.date!, () => _getAllJourneysByDate(journey.date!));
    }
    return mappedJourneys;
  }

  /// Retrieves all journeys for a specific [date].
  List<Journey> _getAllJourneysByDate(DateTime date) {
    List<Journey> journeys = [];
    for (Journey journey in upcomingJourneys) {
      if (journey.date == date) {
        journeys.add(journey);
      }
    }
    return journeys;
  }

  /// Gets all the events happening on a specified [date].
  List<dynamic> _getEventsForDay(DateTime date) {
    DateTime day = DateTime(date.year, date.month, date.day);
    return _events[day] ?? [];
  }
}
