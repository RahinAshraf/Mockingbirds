import 'package:flutter/material.dart';
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
                calendarFormat: CalendarFormat.month,
                firstDay: DateTime.utc(2022, 01, 01),
                lastDay: DateTime.utc(2032, 01, 01),
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
              beforeLineStyle: LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: const EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              alignment: TimelineAlign.start,
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
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
                            " 29 members",
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
              alignment: TimelineAlign.start,
              indicatorStyle: const IndicatorStyle(
                padding: const EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              beforeLineStyle: LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
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
                            " 29 members",
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
              beforeLineStyle: LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              alignment: TimelineAlign.start,
              indicatorStyle: const IndicatorStyle(
                padding: const EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Colors.green,
              ),
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
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
                            " 29 members",
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
              beforeLineStyle: LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              alignment: TimelineAlign.start,
              indicatorStyle: const IndicatorStyle(
                padding: const EdgeInsets.all(5),
                indicatorXY: 0.0,
                width: 10,
                color: Colors.green,
              ),
              endChild: Column(
                children: [
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                    shape: RoundedRectangleBorder(
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
                                " 29 members",
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
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                    shape: RoundedRectangleBorder(
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
                                " 29 members",
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
                ],
              ),
            ),
            TimelineTile(
              beforeLineStyle: LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: const EdgeInsets.all(5),
                indicatorXY: 0.0,
                width: 10,
                color: Colors.green,
              ),
              isLast: true,
              alignment: TimelineAlign.start,
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
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
                            " 29 members",
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
          ],
        ),
      ),
    );
  }
}
