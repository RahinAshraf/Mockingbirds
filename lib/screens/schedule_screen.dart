import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // final Map<DateTime, List> _scheduledEvents = {
  //   DateTime(2019, 4, 3): ['Selected Day in the calendar!'],
  //   DateTime(2019, 4, 5): ['Selected Day in the calendar!'],
  // };
  CalendarFormat format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
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
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF99D2A9),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
              child: Text(
                'Upcoming journeys',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0xFF393939),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TimelineTile(
              isFirst: true,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.manual,
              lineXY: 0.10,
              startChild: Container(
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "23",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 16.0),
                    ),
                    Text(
                      "Feb",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              endChild: Card(
                elevation: 1,
                margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          'Trip to Buckingham Palace',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF393939),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.person_outline_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " 5 members",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.fmd_good_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " Buckingham Palace",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TimelineTile(
              isFirst: false,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.manual,
              lineXY: 0.10,
              startChild: Container(
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "02",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 16.0),
                    ),
                    Text(
                      "April",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              endChild: Card(
                elevation: 1,
                margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          'Trip to London Eye',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF393939),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.person_outline_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " 4 members",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.fmd_good_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " London Eye",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TimelineTile(
              isFirst: false,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.manual,
              lineXY: 0.10,
              startChild: Container(
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "02",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 16.0),
                    ),
                    Text(
                      "May",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              endChild: Card(
                elevation: 1,
                margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          'Trip to London Bridge',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF393939),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.person_outline_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " 3 members",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.fmd_good_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " London Bridge",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TimelineTile(
              isFirst: false,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.manual,
              lineXY: 0.10,
              startChild: Container(
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "05",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 16.0),
                    ),
                    Text(
                      "May",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              endChild: Column(
                children: [
                  Card(
                    elevation: 1,
                    margin: const EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const ListTile(
                            title: Text(
                              'Trip to Regent’s Canal',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF393939),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              SizedBox(width: 15.0),
                              Icon(
                                Icons.person_outline_outlined,
                                color: Colors.black54,
                                size: 15.0,
                              ),
                              Text(
                                " 1 member",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Icon(
                                Icons.fmd_good_outlined,
                                color: Colors.black54,
                                size: 15.0,
                              ),
                              Text(
                                " Regent’s Canal",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const ListTile(
                            title: Text(
                              'Long trip to Westminster Abbey and Notting Hill',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF393939),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Row(
                            children: const [
                              SizedBox(width: 15.0),
                              Icon(
                                Icons.person_outline_outlined,
                                color: Colors.black54,
                                size: 15.0,
                              ),
                              Text(
                                " 6 members",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Icon(
                                Icons.fmd_good_outlined,
                                color: Colors.black54,
                                size: 15.0,
                              ),
                              Text(
                                " Westminster Abbey",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TimelineTile(
              isFirst: false,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.manual,
              lineXY: 0.10,
              startChild: Container(
                padding: EdgeInsets.only(top: 5.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "15",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 16.0),
                    ),
                    Text(
                      "Sept",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          'Cycle around Stratford Olympic Park',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Color(0xFF393939),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.person_outline_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " 2 members",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Icon(
                            Icons.fmd_good_outlined,
                            color: Colors.black54,
                            size: 15.0,
                          ),
                          Text(
                            " Stratford",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
