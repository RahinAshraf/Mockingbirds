import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({Key? key}) : super(key: key);

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
              'Journey',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 25),
            )),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Text(
                'See:',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF99D2A9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 300.0),
              Icon(
                Icons.science,
                color: Color(0xFF99D2A9),
                size: 24.0,
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFF99D2A9),
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: ImageIcon(
                          AssetImage("assets/images/logo.png"),
                          color: Color(0xFF99D2A9),
                          size: 20,
                        ),
                      ),
                      TextSpan(
                          text: "Next station: Station",
                          style: TextStyle(
                              color: Color(0xFF99D2A9), fontSize: 25)),
                    ],
                  )),
                ),
                Row(
                  children: const [
                    SizedBox(width: 15.0),
                    Icon(
                      Icons.timelapse,
                      color: Color(0xFF99D2A9),
                      size: 15.0,
                    ),
                    Text(
                      " 25 mins",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF99D2A9),
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Icon(
                      Icons.map,
                      color: Color(0xFF99D2A9),
                      size: 15.0,
                    ),
                    Text(
                      " 5 km",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF99D2A9),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        const Divider(
          color: Color(0xFF99D2A9),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Text(
            'Whole journey',
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF99D2A9),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TimelineTile(
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
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text(
                      'You          ',
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
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TimelineTile(
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
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
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
        ),
        const SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.timer,
                          color: Color(0xFF99D2A9),
                          size: 15.0,
                        ),
                      ),
                      TextSpan(
                          text: "Total time left:",
                          style: TextStyle(
                              color: Color(0xFF99D2A9), fontSize: 20)),
                    ],
                  )),
                ),
                Row(
                  children: const [
                    SizedBox(width: 15.0),
                    Icon(
                      Icons.timelapse,
                      color: Color(0xFF99D2A9),
                      size: 15.0,
                    ),
                    Text(
                      " 25 mins",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Color(0xFF99D2A9),
                      ),
                    ),
                    SizedBox(width: 30.0),
                  ],
                ),
              ],
            )),
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
              child: const Text('STOP JOURNEY',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {},
            )),
      ],
    ));
  }
}
