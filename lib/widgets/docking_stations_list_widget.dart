import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'docking_station_card.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

/// Class that loads information of docking stations into cards and builds a row of them.
/// Author(s): Tayyibah, Nicole
class DockingStationList {
  DockingStationList(this.userCoordinates); // Constructor

  late List<Widget> dockingStationCards;
  List<Map> cardsData = [];
  LatLng userCoordinates;

  /// Retrieve 10 cards that are closest to a given location for edit dock.
  Future<List<Widget>> retrieveFilteredCards() {
    final dockingStationManager _stationManager = dockingStationManager();
    var cards = _stationManager.importStations().then((value) =>
        createDockingCards(_stationManager.get10ClosestDocks(userCoordinates)));
    return cards;
  }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (int index = 0; index < docks.length; index++) {
      for (var station in docks) {
        cardsData.add(
          {
            'index': index,
            // 'station': station,
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
              cardsData[index]['stationId'],
              cardsData[index]['name'],
              cardsData[index]['numberOfBikes'],
              cardsData[index]['numberOfEmptyDocks'],
            ));

    return dockingStationCards;
  }

  FutureBuilder<List<Widget>> build() {
    return FutureBuilder<List<Widget>>(
        future: retrieveFilteredCards(),
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
