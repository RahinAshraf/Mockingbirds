import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import '../../models/itinerary.dart';
import '../../helpers/database_helpers/schedule_helper.dart';
import '../../styles/styling.dart';

///Author: Marija
///Contributor: Tayyibah
class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late List<Itinerary> journeyList = [];
  var helper = ScheduleHelper();

  _SchedulePageState();

  @override
  initState() {
    helper.getAllScheduleDocuments().then((data) {
      setState(() {
        journeyList = data;
      });
    });
    //print("THE LENGTH IS:" + journeyList[.length.toString()]);
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
            Column(
              //present some text if the length of journey list is 0 (e.g. 'you havent scheduled any journeys yet')
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var item in journeyList)
                  TimelineItem(item, journeyList.indexOf(item))
              ],
              // FutureBuilder(
              // children: FutureBuilder(
              // future: getJourneyFromDatabase(),
              // builder: (context, snapshot) {
              //   return Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         for (var item in journeyList)
              //           TimelineItem(item, journeyList.indexOf(item))
              //       ]);
              // },
              // <Widget>[
              //   for (var item in  journeyList)
              //     TimelineItem(item, journeyList.indexOf(item))
              // ],
            ),

            //     itemCount: journeyList.length),
            // TODO: instead of manually generating timeline items, pass a list (map?) of upcoming journeys
            //TimelineItem(journeyList[0], 0),

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
  final Itinerary journey;
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
    'Dec',
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
      endChild: UpcomingEventCard(title: "TRIP", journey: journey),
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
  const UpcomingEventCard({required this.title, required this.journey});

  final String title;
  final Itinerary journey;

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
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: eventCardDetailsTextStyle,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SummaryJourneyScreen(journey)));
                  },
                  child: const Text("View journey itinerary"),
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
