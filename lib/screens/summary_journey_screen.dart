import 'package:flutter/material.dart';

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
        const SizedBox(height: 30),
        Container(
            height: 120.0,
            width: 120.0,
            child: Center(
                child: Image.asset('assets/images/summary_journey.png'))),
        const SizedBox(height: 30),
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
                child: Icon(
                  Icons.map_outlined,
                  size: 25,
                  color: Color(0xFF99D2A9),
                ),
              ),
              TextSpan(
                  text: "Planned stops:",
                  style: TextStyle(color: Color(0xFF99D2A9), fontSize: 25)),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Final stop:',
              style: TextStyle(color: Color(0xFF99D2A9), fontSize: 18),
            )),
        const SizedBox(height: 30),
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
