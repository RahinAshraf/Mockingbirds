import '../docking_station_card.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'custom_carousel.dart';

///Class that loads information of docking stations into cards and builds a carousel
///@author Tayyibah Uddin
class dockingStationCarousel {
  late List<Widget> dockingStationCards;
  List<Map> carouselData = [];

  AllDocksCard() {
    retrieveAllCards();
  }

  Future<List<Widget>> retrieveAllCards() {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = _stationManager
        .importStations()
        .then((value) => createDockingCards(_stationManager.stations));
    return list;
  }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (int index = 0; index < docks.length; index++) {
      for (var station in docks) {
        carouselData.add(
          {
            'index': index,
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
              //carouselData[index]['index'],
              // carouselData[index]['station'],
              carouselData[index]['stationId'],
              carouselData[index]['name'],
              carouselData[index]['numberOfBikes'],
              carouselData[index]['numberOfEmptyDocks'],
            ));

    return dockingStationCards;
  }

  FutureBuilder<List<Widget>> buildCarousel() {
    return FutureBuilder<List<Widget>>(
        future: retrieveAllCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                  height: 200,
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
}
