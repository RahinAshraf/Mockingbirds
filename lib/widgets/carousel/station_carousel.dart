import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/widgets/carousel/custom_carousel.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

/// Class that loads information of docking stations into cards and builds a carousel.
/// Author(s): Tayyibah, Nicole
class DockingStationCarousel {
  DockingStationCarousel([this.userCoordinates]);

  late List<Widget> dockingStationCards = [];
  List<Map> carouselData = [];
  LatLng? userCoordinates;

  final dockingStationManager _stationManager = dockingStationManager();

  /// Retrieves 10 filtered by distance cards closest to given [userCoordinates].
  Future<List<Widget>> retrieve10FilteredByDistanceCards() async {
    var cards = _stationManager.importStations().then((value) =>
        createDockingCards(
            _stationManager.get10ClosestDocks(userCoordinates!)));
    return cards;
  }

  /// Retrieves 10 (or less) favourited cards closest to given [userCoordinates].
  Future<List<Widget>> retrieve10FilteredFavouritesCards() async {
    List<DockingStation> favourites = [];
    favourites = await FavouriteHelper.getUserFavourites();
    return createDockingCards(
        _stationManager.get10ClosestDocksFav(userCoordinates!, favourites));
  }

  /// Generates [dockingStationCards] from the data in [docks].
  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (var station in docks) {
      carouselData.add({'station': station});
    }
    dockingStationCards = List<Widget>.generate(
        docks.length,
        (index) => DockingStationCard.station(
              carouselData[index]["station"],
            ));

    return dockingStationCards;
  }

  /// Based on [filter], selects what cards should be fetched.
  Future<List<Widget>> selectFiltering(String filter) {
    if (filter == "Distance") {
      return retrieve10FilteredByDistanceCards();
    } else {
      return retrieve10FilteredFavouritesCards();
    }
  }

  /// Builds a carousel out of given [cards].
  Widget buildCarousel(List<Widget> cards) {
    return CustomCarousel(cards: cards);
  }

  /// Builds filtered carousel consisting of cards filtered by [selectedFilter].
  FutureBuilder<List<Widget>> buildFilteredCarousel(String selectedFilter) {
    return FutureBuilder(
        future: selectFiltering(selectedFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/bike.png', height: 100),
                    SizedBox(height: 10),
                    Text('Nothing to see here.',
                        style: Theme.of(context).textTheme.headline5),
                  ],
                );
              }
              return Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: CustomCarousel(cards: dockingStationCards),
              );
            } else {
              return Text('Error: ${snapshot.hasError}');
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
