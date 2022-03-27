import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import '../models/itinerary.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../styles/styling.dart';

/// Suggester itineraries that contain biggest sights in London for under 30 min.
/// from: https://londonblog.tfl.gov.uk/2019/11/05/santander-cycles-sightseeing/?intcmp=60245
///Author: Nicole
class SuggestedItinerary extends StatefulWidget {
  @override
  _SuggestedItineraryState createState() => _SuggestedItineraryState();
}

class _SuggestedItineraryState extends State<SuggestedItinerary> {
  late Itinerary _hydeLoop;
  late Itinerary _royalLoop;
  List<LatLng> _hydeParkLoopCoord = [
    LatLng(51.5031, 0.1526),
    LatLng(51.50883, -0.17166),
    LatLng(51.5046, 51.5046),
    LatLng(51.5045099, -0.152706),
    LatLng(51.5121347, -0.1686248),
    LatLng(51.5066092, -0.1745202),
  ];
  List<LatLng> _royalLoopCoord = [
    LatLng(51.5058442, -0.1647927),
    LatLng(51.5025958, -0.1530432),
    LatLng(51.501364, -0.14189),
    LatLng(51.511853, -0.1986145),
    LatLng(51.5021618, -0.1315459),
    LatLng(51.5057222, -0.1330674),
    LatLng(51.5018847, -0.1428112),
  ];

  _SuggestedItineraryState() {
    this._hydeLoop =
        new Itinerary.suggestedTrip(_hydeParkLoopCoord, "Hyde Park Loop");
    this._royalLoop =
        new Itinerary.suggestedTrip(_royalLoopCoord, "Royal Loop");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteReplacement,
      appBar: AppBar(
        title: const Text('Suggested Journeys'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
                height: 150.0,
                width: 150.0,
                child: Center(
                    child: Image.asset('assets/images/suggested_trips.png'))),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
              child: Text('Explore London', style: upcomingJourneysTextStyle),
            ),
            Column(
              //present some text if the length of journey list is 0 (e.g. 'you havent scheduled any journeys yet')
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TimelineItem(_royalLoop, 1),
                TimelineItem(_hydeLoop, 2)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Creates a timeline tile.
/// The list [upcomingEventCards] should already contain all the events
/// of a user on the same date, sorted from earliest to latest.
class TimelineItem extends StatelessWidget {
  final Itinerary journey;
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
      endChild: UpcomingEventCard(
          title: journey.journeyDocumentId!, journey: journey),
    );
  }
}

/// Generates an event card for schedule screen.
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
                    // TODO: change to call the summary of journey
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => SummaryJourneyScreen(journey)));
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
