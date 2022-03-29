import 'dart:core';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/schedule_helper.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/widgets/upcoming_event_card.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleHelper helper = ScheduleHelper();
  DatabaseManager _databaseManager = DatabaseManager();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  late List<Itinerary> upcomingJourneys = [];
  late Map<DateTime, List<Itinerary>> _events = {};
  late List _selectedEvents = [];
  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  DateTime _focusedDay = DateUtils.dateOnly(DateTime.now());

  @override
  initState() {
    _deleteOldScheduledTrips();
    helper.getAllScheduleDocuments().then((data) {
      setState(() {
        upcomingJourneys = data;
        _events = _groupByDate(upcomingJourneys);
        _selectedEvents = _events[_selectedDay] ?? [];
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
              calendarStyle: scheduleScreenCalendarStyle,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateUtils.dateOnly(DateTime.now()),
              lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month,
                  DateTime.now().day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text('Upcoming journeys', style: upcomingJourneysTextStyle),
          ),
          (!_selectedEvents.isEmpty)
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      for (var event in _selectedEvents)
                        UpcomingEventCard(
                          event: event,
                          onClick: () {
                            var _schedulesReference = _databaseManager
                                .getUserSubCollectionReference('schedules');
                            _databaseManager.deleteDocument(
                                _schedulesReference, event.journeyDocumentId!);
                            setState(() {
                              var journeyToRemove = upcomingJourneys.where(
                                  (journey) =>
                                      journey.journeyDocumentId ==
                                      event.journeyDocumentId);
                              upcomingJourneys.remove(journeyToRemove);
                              _events = _groupByDate(upcomingJourneys);
                              _selectedEvents = _events[_selectedDay] ?? [];
                            });
                            Navigator.pop(context);
                          },
                        )
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Image.asset('assets/images/bike.png',
                          height: MediaQuery.of(context).size.height / 3.5),
                      SizedBox(height: 15.0),
                      Text(
                        'No journeys planned for today.',
                        style: authTextStyle,
                      ),
                    ],
                  ),
                ),
        ],
      ),
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

  /// Checks for and deletes user's expired trips from the database.
  Future<void> _deleteOldScheduledTrips() async {
    var scheduledJourneys =
        await _databaseManager.getUserSubcollection('schedules');
    scheduledJourneys.docs.forEach((element) {
      DateTime date = element.get('date').toDate();
      if (DateUtils.dateOnly(DateTime.now()).isAfter(date)) {
        element.reference.delete();
      }
    });
  }
}
