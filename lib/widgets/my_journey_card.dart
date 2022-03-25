import 'package:flutter/material.dart';
import '/models/journey.dart';
import '../widgets/carousel/station_carousel.dart';

///Creates a card for a started journey, to include its start time and planned docking stations
///Author: Tayyibah
class MyJourneyCard extends StatefulWidget {
  late Journey journey;
  DockingStationCarousel stationCarousel =
      DockingStationCarousel.test(); //change this
  late List<Widget> stationCards;

  MyJourneyCard(Journey journey) {
    this.journey = journey;
    this.stationCards =
        stationCarousel.createDockingCards(journey.stationList!);
  }

  @override
  _MyJourneyCardState createState() => _MyJourneyCardState();
}

class _MyJourneyCardState extends State<MyJourneyCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.green[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.journey.date!.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      child: widget.stationCarousel
                          .buildCarousel(widget.stationCards)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
