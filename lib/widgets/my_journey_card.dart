import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';

/// Creates a card for a started journey, to include its start time and planned docking stations
/// Author: Tayyibah
/// Contributor: Marija
class MyJourneyCard extends StatefulWidget {
  late Itinerary journey;
  DockingStationCarousel stationCarousel = DockingStationCarousel();
  late List<Widget> stationCards;

  MyJourneyCard(Itinerary journey) {
    this.journey = journey;
    this.stationCards = stationCarousel.createDockingCards(journey.docks!);
  }

  @override
  _MyJourneyCardState createState() => _MyJourneyCardState();
}

class _MyJourneyCardState extends State<MyJourneyCard> {
  @override
  Widget build(BuildContext context) {
    DateTime date = widget.journey.date!;
    _addDateCard(date);
    return widget.stationCarousel.buildCarousel(widget.stationCards);
  }

  /// Generates and adds card with a [date] to the carousel.
  void _addDateCard(date) {
    var cardToAdd = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Card(
          elevation: 1,
          color: Colors.white,
          shadowColor: CustomColors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${DateFormat.MMMMEEEEd().format(widget.journey.date!)}, ${date.year}',
                style: CustomTextStyles.headline2,
              ),
              Text(
                '${DateFormat('hh:mm a').format(date)}',
                style: CustomTextStyles.placeholderText,
              ),
            ],
          ),
        ));
    widget.stationCards.insert(0, cardToAdd);
  }
}
