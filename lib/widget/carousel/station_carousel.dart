import 'docking_station_card.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/utilities/docking_station_manager.dart';
import 'custom_carousel.dart';

///Class that loads information of docking stations into cards and builds a carousel
class dockingStationCarousel {
  late List<Widget> dockingStationCards;
  List<Map> carouselData = [];

  AllDocksCard() {
    retrieveAllCards();
  }

  List<Widget> retrieveAllCards() {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = createDockingCards(_stationManager.stations);
    return list;
  }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (int index = 0; index < docks.length; index++) {
      for (var station in docks) {
        carouselData.add(
          {
            'index': index,
            'name': station.name,
            'nb_bikes': station.nb_bikes.toString(),
            'nb_empty_docks': station.nb_empty_docks.toString()
          },
        );
      }
    }

    dockingStationCards = List<Widget>.generate(
        docks.length,
        (index) => dockingStationCard(
              carouselData[index]['index'],
              carouselData[index]['name'],
              carouselData[index]['nb_bikes'],
              carouselData[index]['nb_empty_docks'],
            ));

    return dockingStationCards;
  }

  // FutureBuilder<List<Widget>> buildCarousel() {
  //   return FutureBuilder<List<Widget>>(
  //       future: retrieveAllCards(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return Stack(
  //             children: [
  //               Container(
  //                 height: 200,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: CustomCarousel(cards: dockingStationCards),
  //               )
  //             ],
  //           );
  //         } else {
  //           return SizedBox(
  //             height: MediaQuery.of(context).size.height / 1.3,
  //             child: Center(
  //               child: CircularProgressIndicator(),
  //             ),
  //           );
  //         }
  //       });
  // }

  Container buildCarousel(context) {
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: CustomCarousel(cards: dockingStationCards));
  }
}
