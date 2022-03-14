import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SummaryJourneyScreen extends StatelessWidget {
  const SummaryJourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: const Text(
              'Summary of Journey',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
            )),
        //const SizedBox(height: 30),
        Container(
            height: 120.0,
            width: 120.0,
            child: Center(
                child: Image.asset('assets/images/summary_journey.png'))),
        //const SizedBox(height: 30),
        Container(
            height: 30,
            padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('Organiser:',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
        Container(
            height: 30,
            padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('Group ID:',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
        const SizedBox(height: 30),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: ImageIcon(
                AssetImage("assets/images/logo.png"),
                color: Color(0xFF99D2A9),
                size: 24,
              )),
              TextSpan(
                  text: "Planned stops:",
                  style: TextStyle(color: Color(0xFF99D2A9), fontSize: 25)),
            ],
          ),
        ),
        const SizedBox(height: 30),
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
            color: Color(0xFF99D2A9),
          ),
          alignment: TimelineAlign.start,
          endChild: Card(
            elevation: 1,
            margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'Station 1',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 200.0),
                  ImageIcon(
                    AssetImage("assets/images/logo.png"),
                    color: Color(0xFF99D2A9),
                    size: 24,
                  )
                ],
              ),
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
            color: Color(0xFF99D2A9),
          ),
          alignment: TimelineAlign.start,
          endChild: Card(
            elevation: 1,
            margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'Station 2',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 200.0),
                  ImageIcon(
                    AssetImage("assets/images/logo.png"),
                    color: Color(0xFF99D2A9),
                    size: 24,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Final stop:',
              style: TextStyle(color: Color(0xFF99D2A9), fontSize: 18),
            )),
        const SizedBox(height: 20),
        Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('START THE JOURNEY',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
      ],
    ));
  }
}
