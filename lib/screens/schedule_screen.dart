import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/helpers/schedule_helper.dart';
import 'package:veloplan/models/journey.dart';
import 'package:veloplan/styles/styling.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Journey> journeys = [];
  var helper = ScheduleHelper();

  @override
  void initState() {
    helper.getAllScheduleDocuments().then((data) {
      setState(() {
        journeys = data;
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
              calendarFormat: CalendarFormat.week,
              firstDay: DateTime.utc(2022, 01, 01),
              lastDay: DateTime.utc(2023, 01, 01),
              focusedDay: DateTime.now(),
              calendarStyle: scheduleScreenCalendarStyle,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
            child: Text('Upcoming journeys', style: upcomingJourneysTextStyle),
          ),
          Column(
            children: [
              for (var item in journeys)
                TimelineItem(item, journeys.indexOf(item))
            ],
          ),
        ],
      ),
    );
  }
}

/// Creates a timeline tile.
///
/// This widget generates a timeline tile used in [SchedulePage].
/// It is used along with [UpcomingEventCard]. The [day] and the
/// [month] properties are used together and correspond to [startChild]
/// property of [TimelineTile], and [upcomingEventCards] correspond to
/// [endChild] property of [TimelineTile].
///
/// The [day] property must be a valid day number 0-31 and the [month] property
/// should be a shortened month name, no more than 5 characters long to avoid
/// distorted widget.
///
/// The list [upcomingEventCards] should already contain all the events
/// of a user on the same date, sorted from earliest to latest.
class TimelineItem extends StatelessWidget {
  final Journey journey;
  final int index;
  TimelineItem(this.journey, this.index);

  List<String> months = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: index == 0 ? true : false,
      beforeLineStyle: timelineTileBeforeLineStyle,
      indicatorStyle: timelineTileIndicatorStyle,
      alignment: TimelineAlign.manual,
      lineXY: 0.10,
      startChild: Container(
        padding: const EdgeInsets.only(top: 5.0),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(journey.date!.day.toString(), style: timelineTileDayTextStyle),
            Text(months[journey.date!.month + 1].toString(),
                style: timelineTileMonthTextStyle),
          ],
        ),
      ),
      endChild: UpcomingEventCard(title: 'Title', number: 5),
    );
  }
}

/// Generates an event card for schedule screen.
///
/// This widget generates a card of an event displayed in
/// [SchedulePage], under upcoming journeys. It takes [title] and
/// [number] of people in the trip. At this stage, it is not concerned with the
/// date of the trip. These cards are designed to be used with [TimelineItem].
class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({required this.title, required this.number});

  final String title;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 5.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      )),
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 15.0, left: 15.0, right: 15.0, top: 15.0),
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: eventCardTitleTextStyle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "View journey itinerary",
                      style: eventCardDetailsTextStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black54,
                      size: 15.0,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${number}",
                      style: eventCardDetailsTextStyle,
                    ),
                    const Icon(
                      Icons.person,
                      color: Colors.black54,
                      size: 15.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
