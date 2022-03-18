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
        child: FloatingActionButton(onPressed: () {
          //  helper.getDockingStationsInJourney("c1QnH3tKi7RC352sgm8i");
          // helper.getAllJourneys();
          // print("here");
          // helper.deleteDockingStations("UvCmTAFcbMSA1tprUy6T");
        }),
      ),
    );
  }
}
