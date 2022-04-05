import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/styles/texts.dart';

/// Suggested itineraries that contain popular touristic sights in London in under 30 minutes.
/// Author: Nicole Lehchevska
/// Contributor: Marija
class SuggestedItinerary extends StatefulWidget {
  @override
  _SuggestedItineraryState createState() => _SuggestedItineraryState();
}

class _SuggestedItineraryState extends State<SuggestedItinerary> {
  late Itinerary _hydeLoop;
  late Itinerary _royalLoop;
  late Itinerary _thamesLoop;

  Map<LatLng, String> _hydeParkLoopCoord = {
    LatLng(51.5031, -0.1526): "BikePoints_191",
    LatLng(51.50883, -0.17166): "BikePoints_248",
    LatLng(51.5045099, -0.152706): "BikePoints_733",
    LatLng(51.5121347, -0.1686248): "BikePoints_153",
    LatLng(51.5066092, -0.1745202): "BikePoints_300"
  };
  Map<LatLng, String> _royalLoopCoord = {
    LatLng(51.5058442, -0.1647927): "BikePoints_248",
    LatLng(51.5025958, -0.1530432): "BikePoints_191",
    LatLng(51.501364, -0.14189): "BikePoints_213",
    LatLng(51.5021618, -0.1315459): "BikePoints_762",
    LatLng(51.5057222, -0.1330674): "BikePoints_160",
    LatLng(51.5018847, -0.1428112): "BikePoints_213"
  };
  Map<LatLng, String> _thamesLoopCoord = {
    LatLng(51.4993832, -0.1286692): "BikePoints_762",
    LatLng(51.4994827, -0.1269979): "BikePoints_818",
    LatLng(51.5110623, -0.1193367): "BikePoints_309",
    LatLng(51.5138486, -0.1005393): "BikePoints_48",
    LatLng(51.5081157, -0.078138): "BikePoints_130",
    LatLng(51.505455, -0.0753537): "BikePoints_278",
    LatLng(51.5075986, -0.101545): "BikePoints_839",
    LatLng(51.5031122, -0.1211524): "BikePoints_815"
  };
  @override
  void initState() {
    List<Itinerary> itineraries = [];

    this._hydeLoop = Itinerary.suggestedTrip(_hydeParkLoopCoord.keys.toList(),
        "Hyde Park Loop", _hydeParkLoopCoord.values.toList(), DateTime.now());
    itineraries.add(_hydeLoop);

    this._royalLoop = Itinerary.suggestedTrip(_royalLoopCoord.keys.toList(),
        "Royal Loop", _royalLoopCoord.values.toList(), DateTime.now());
    itineraries.add(_royalLoop);

    this._thamesLoop = Itinerary.suggestedTrip(_thamesLoopCoord.keys.toList(),
        "Thames Loop", _thamesLoopCoord.values.toList(), DateTime.now());
    itineraries.add(_thamesLoop);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteReplacement,
      appBar: AppBar(
        title: const Text('Suggested Journeys'),
        leading: BackButton(key: Key("back"), color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
              child: Text('Explore London',
                  style: Theme.of(context).textTheme.headline1),
            ),
            Column(
              children: [
                TimelineItem(_royalLoop, 0),
                TimelineItem(_hydeLoop, 1),
                TimelineItem(_thamesLoop, 2)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Creates a timeline tile with [ItineraryCard].
class TimelineItem extends StatelessWidget {
  final Itinerary journey;
  final int index;
  TimelineItem(this.journey, this.index);

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: index == 0 ? true : false,
      beforeLineStyle: timelineTileBeforeLineStyle,
      indicatorStyle: timelineTileIndicatorXYStart,
      alignment: TimelineAlign.manual,
      lineXY: 0.05,
      endChild:
          ItineraryCard(title: journey.journeyDocumentId!, journey: journey),
    );
  }
}

/// Generates a card for the suggested journey.
class ItineraryCard extends StatelessWidget {
  const ItineraryCard({required this.title, required this.journey});

  final String title;
  final Itinerary journey;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 10.0),
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
              title: Text(title, style: Theme.of(context).textTheme.headline2),
            ),
            SizedBox(
              height: 200.0,
              width: 200.0,
              child: _retrieveImage(title),
            ),
            Row(
              children: [
                const SizedBox(width: 15.0),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: CustomTextStyles.eventCardDetailsTextStyle,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SummaryJourneyScreen(journey, true)));
                  },
                  child: const Text("View itinerary"),
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

  /// Retrieve the image for the suggested journey card.
  _retrieveImage(title) {
    if (title == "Royal Loop") return Image.asset('assets/images/bigBen.png');
    if (title == "Hyde Park Loop")
      return Image.asset('assets/images/hydePark.png');
    if (title == "Thames Loop")
      return Image.asset('assets/images/westminster.png');
  }
}
