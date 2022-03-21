import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../helpers/schedule_helper.dart';
import '../models/journey.dart';
import '../styles/styling.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Journey> journeyList = [];
  var helper = ScheduleHelper();

  @override
  void initState() {
    helper.getAllJourneyDocuments().then((data) {
      setState(() {
        journeyList = data;
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
      body: SafeArea(
        child: ListView(
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
              child:
                  Text('Upcoming journeys', style: upcomingJourneysTextStyle),
            ),
            // ListView.builder(
            //     itemBuilder: (context, index) {
            //       return TimelineItem(
            //         journeyList[index],
            //         index,
            //       );
            //     },
            //     itemCount: journeyList.length),
            // TODO: instead of manually generating timeline items, pass a list (map?) of upcoming journeys
            TimelineItem(journeyList[0], 0),

            // const TimelineItem(month: "March", day: "3", upcomingEventCards: [
            //   UpcomingEventCard(title: "Trip to London Bridge")
            // ]),
            // const TimelineItem(month: "May", day: "1", upcomingEventCards: [
            //   UpcomingEventCard(title: "Cycle around Stratford")
            // ]),
            // const TimelineItem(
            //   day: "16",
            //   month: "Aug",
            //   upcomingEventCards: [
            //     UpcomingEventCard(
            //         title: "Biking society's trip to Regent's Park")
            //   ],
            // ),
            // const TimelineItem(
            //   day: "31",
            //   month: "Sept",
            //   upcomingEventCards: [
            //     UpcomingEventCard(title: "Trip to London Bridge"),
            //     UpcomingEventCard(title: "Trip to Science Museum"),
            //   ],
            // )
          ],
        ),
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
            Text(journey.date!, style: timelineTileDayTextStyle),
            // Text(month, style: timelineTileMonthTextStyle),
          ],
        ),
      ),
      endChild: UpcomingEventCard(title: 'TRIP:D'),
    );
  }
}

/// Generates an event card for schedule screen.
///
/// This widget generates a card of an event displayed in
/// schedule screen, under upcoming journeys. It takes [title],
/// [number] of people in the trip, and the [time] when the trip
/// takes place. At this stage, it is not concerned with the date
/// of the trip. These cards were designed to be used with [TimelineItem].
class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({required this.title});

  final String title;

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
          children: <Widget>[
            ListTile(
              title: Text(title, style: eventCardTitleTextStyle),
            ),
            Row(
              children: [
                const SizedBox(width: 15.0),
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
          ],
        ),
      ),
    );
  }
}
