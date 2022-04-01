import 'package:flutter/material.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/styles/colors.dart';
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
    return Card(
      elevation: 1.0,
      shadowColor: CustomColors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Text(
            widget.journey.date!.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.23,
              child: widget.stationCarousel.buildCarousel(widget.stationCards)),
        ],
      ),
    );
  }
}
