import 'docking_station_card.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

/// Class that loads information of docking stations onto cards
class DockingStationList {
  late List<Widget> dockingStationCards;
  List<Map> cardData = [];

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
        cardData.add(
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
              cardData[index]['index'],
              cardData[index]['name'],
              cardData[index]['nb_bikes'],
              cardData[index]['nb_empty_docks'],
            ));

    return dockingStationCards;
  }

  FutureBuilder<List<Widget>> build() {
    return FutureBuilder<List<Widget>>(
        future: retrieveAllCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dockingStationCards,
              ),
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
