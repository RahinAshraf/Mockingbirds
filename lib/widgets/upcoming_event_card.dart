import 'package:flutter/material.dart';
import 'package:veloplan/models/journey.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/styles/styling.dart';

/// Generates an event card for schedule screen.
///
/// This widget generates a card of an event displayed in
/// [SchedulePage], under upcoming journeys. It takes [journey] as
/// argument and displays its information on a card.
class UpcomingEventCard extends StatelessWidget {
  UpcomingEventCard({required this.journey});

  final Journey journey;
  var name;
  String text = "";

  /// Generate the names of the paths from coordinates
  Future<void> _generateNames(double lat, double lon) async {
    LocationService service = LocationService();
    service.reverseGeoCode(lat, lon).then((value) {
      text = value['place_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _generateNames(journey.myDestinations[0].latitude,
        journey.myDestinations[0].longitude);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip ${text}', style: eventCardTitleTextStyle),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "View journey itinerary",
                      style: eventCardDetailsTextStyle,
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black54, size: 15.0),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${journey.numberOfCyclists}",
                      style: eventCardDetailsTextStyle,
                    ),
                    const Icon(Icons.person, color: Colors.black54, size: 15.0),
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
