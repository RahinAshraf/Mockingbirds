import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';

/// Creates a card for a started journey, to include its start time and planned docking stations
/// Author: Tayyibah
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
    String formattedDate = DateFormat.MMMMEEEEd().format(date);
    _addDateCard(date, formattedDate);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        height: MediaQuery.of(context).size.height * 0.23,
        child: widget.stationCarousel.buildCarousel(widget.stationCards));
  }

  /// Adds a date card to the carousel.
  void _addDateCard(date, formattedDate) {
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
                '${formattedDate}, ${date.year}',
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
