import 'package:flutter/material.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';

/// Generates an event card for schedule screen.
///
/// This widget generates a card of an event displayed in
/// [ScheduleScreen], under upcoming journeys. It takes [event] as an
/// argument and displays its information on a card.
///
/// [onClick] is required to specify the function that should be executed
/// when delete button is clicked.
/// Author: Marija
class UpcomingEventCard extends StatelessWidget {
  UpcomingEventCard({required this.event, required this.onClick});

  final Itinerary event;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        splashColor: CustomColors.green.withAlpha(30),
        overlayColor: MaterialStateProperty.all(Colors.green.withAlpha(30)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => SummaryJourneyScreen(event, true)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trip title', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 20.0),
              Text("Tap on the card to view journey itinerary.",
                  style: CustomTextStyles.eventCardDetailsTextStyle),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "${event.numberOfCyclists}",
                        style: CustomTextStyles.eventCardDetailsTextStyle,
                      ),
                      const Icon(Icons.person,
                          color: Colors.black54, size: 15.0),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.cancel_outlined, size: 15.0),
                    splashRadius: 16.0,
                    onPressed: () {
                      var popup = Popups();
                      showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (BuildContext context) =>
                              popup.buildPopupDialogDeleteScheduledJourney(
                                  context, onClick));
                    },
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    color: Colors.black54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
