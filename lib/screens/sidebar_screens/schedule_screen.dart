import 'dart:core';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:veloplan/helpers/database_helpers/schedule_helper.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/upcoming_event_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

/// Renders a schedule screen.
///
/// It consists of [TableCalendar] with a collection of [_events] retrieved
/// from [upcomingJourneys]. [_selectedEvents] are the events of [_selectedDay].
/// Author: Marija
class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<Itinerary> upcomingJourneys = [];
  late Map<DateTime, List<Itinerary>> _events = {};
  ScheduleHelper helper = ScheduleHelper();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  DateTime _focusedDay = DateUtils.dateOnly(DateTime.now());

  @override
  initState() {
    super.initState();
    helper
        .deleteOldScheduledEntries()
        .whenComplete(() => helper.getAllScheduleDocuments().then((data) {
              setState(() {
                upcomingJourneys = data;
                _events = _groupByDate(upcomingJourneys);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteReplacement,
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildCalendar(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Upcoming journeys',
                style: Theme.of(context).textTheme.headline1),
          ),
          _getEventsForDay(_selectedDay).isEmpty
              ? Container(
                  child: Column(
                    children: [
                      Image.asset('assets/images/bike.png',
                          height: MediaQuery.of(context).size.height / 3.5),
                      SizedBox(height: 15.0),
                      Text(
                        'No journeys planned for this day.',
                        style: CustomTextStyles.placeholderText,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: _getEventsForDay(_selectedDay)
                        .map((Itinerary event) => UpcomingEventCard(
                              event: event,
                              onClick: () {
                                helper
                                    .deleteSingleScheduledEntry(event)
                                    .whenComplete(() => setState(() {
                                          _events =
                                              _groupByDate(upcomingJourneys);
                                        }));
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
                              },
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  /// Builds calendar for the schedule page.
  Widget _buildCalendar() {
    return TableCalendar(
      eventLoader: _getEventsForDay,
      calendarStyle: scheduleScreenCalendarStyle,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      firstDay: DateUtils.dateOnly(DateTime.now()),
      lastDay: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
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
    );
  }

  /// Gets all the events happening on a specified [date].
  List<Itinerary> _getEventsForDay(DateTime date) {
    return _events[DateUtils.dateOnly(date)] ?? [];
  }

  /// Groups [journeys] based on their date.
  Map<DateTime, List<Itinerary>> _groupByDate(List<Itinerary> journeys) {
    Map<DateTime, List<Itinerary>> mappedJourneys = {};
    for (Itinerary journey in journeys) {
      mappedJourneys.putIfAbsent(
          journey.date!, () => _getAllJourneysByDate(journey.date!));
    }
    return mappedJourneys;
  }

  /// Retrieves all journeys for a specific [date].
  List<Itinerary> _getAllJourneysByDate(DateTime date) {
    List<Itinerary> journeys = [];
    for (Itinerary journey in upcomingJourneys) {
      if (journey.date == date) {
        journeys.add(journey);
      }
    }
    return journeys;
  }
}
