import 'docking_station_card.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

class AllDocksCarousel {
  late List<Widget> dockingStationCards;
  List<Map> carouselData = [];

  AllDocksCarousel() {
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
}
