import 'package:flutter/material.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/styles/styling.dart';

/// Generates an event card for schedule screen.
///
/// This widget generates a card of an event displayed in
/// [ScheduleScreen], under upcoming journeys. It takes [event] as an
/// argument and displays its information on a card.
class UpcomingEventCard extends StatelessWidget {
  UpcomingEventCard({required this.event});

  final Itinerary event;

  @override
  Widget build(BuildContext context) {
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
            Text('Trip title', style: eventCardTitleTextStyle),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: eventCardDetailsTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  SummaryJourneyScreen(event)),
                        );
                      },
                      child: const Text("View journey itinerary"),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black54, size: 15.0),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "${event.numberOfCyclists}",
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
