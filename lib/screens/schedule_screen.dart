import 'package:flutter/material.dart';
import 'package:veloplan/widgets/carousel/custom_carousel.dart';
import '../styles/styling.dart';
import '../helpers/history_helper.dart';
import '../widgets/carousel/station_carousel.dart';

class Schedule extends StatelessWidget {
  HistoryHelper helper = new HistoryHelper();
  dockingStationCarousel stationCarousel = new dockingStationCarousel.test();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Container(child: stationCarousel.buildJourneyCarousel()),

        //  FloatingActionButton(onPressed: () {
        //   helper.getDockingStationsInJourney("kzAIWV0no6spala5FhZu");
        //   //  helper.getAllTimes();
        //   // print("here");
        //   // helper.deleteDockingStations("UvCmTAFcbMSA1tprUy6T");
        // }),
      ),
    );
  }
}
