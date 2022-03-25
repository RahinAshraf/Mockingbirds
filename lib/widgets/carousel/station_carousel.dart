import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/widgets/carousel/custom_carousel.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

///Class that loads information of docking stations into cards and builds a carousel
///Author(s): Tayyibah, Nicole
class DockingStationCarousel {
  late List<Widget> dockingStationCards;
  List<Map> carouselData = [];
  LatLng? userCoordinates;

  DockingStationCarousel(this.userCoordinates);
  DockingStationCarousel.test() {
    retrieveAllCards(); //just to initialise for now delete later
  }

  Future<List<Widget>> retrieveAllCards() {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = _stationManager
        .importStations()
        .then((value) => createDockingCards(_stationManager.stations));
    return list;
  }

  /// Retrieve the filtered cards for edit dock. Get 10 cards that are the closest to the given location
  Future<List<Widget>> retrieveFilteredCards() {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = _stationManager.importStations().then((value) =>
        createDockingCards(
            _stationManager.get10ClosestDocks(userCoordinates!)));
    return list;
  }

  // List<Widget> retrieveJourneyCards() {
  //   HistoryHelper historyHelper = new HistoryHelper();
  //   var list = historyHelper.getDockingStationListFromSingleJourney();
  //   return createDockingCards(list);
  // }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (int index = 0; index < docks.length; index++) {
      for (var station in docks) {
        carouselData.add(
          {
            //    'index': index,
            //  'station': station,
            'stationId': station.stationId,
            'name': station.name,
            'numberOfBikes': station.numberOfBikes,
            'numberOfEmptyDocks': station.numberOfEmptyDocks,
          },
        );
      }
    }
    dockingStationCards = List<Widget>.generate(
        docks.length,
        (index) => DockingStationCard(
              carouselData[index]['stationId'],
              carouselData[index]['name'],
            ));

    return dockingStationCards;
  }

  FutureBuilder<List<Widget>> build() {
    return FutureBuilder<List<Widget>>(
        future: retrieveFilteredCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: CustomCarousel(cards: dockingStationCards),
                )
              ],
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  //THIS MUST BE REFACTORED BY TAYYIBAH AND NIKKI:

  Container buildCarousel(List<Widget> cardsIn) {
    return Container(
      height: 200,
      child: CustomCarousel(cards: cardsIn),
    );
  }
}
