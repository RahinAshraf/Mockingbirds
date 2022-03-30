import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/widgets/carousel/custom_carousel.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

/// Loads information of docking stations into cards and builds a carousel.
/// Author(s): Tayyibah, Nicole
class DockingStationCarousel {
  DockingStationCarousel([this.userCoordinates]);

  final dockingStationManager _stationManager = dockingStationManager();
  late List<Widget> _dockingStationCards = [];
  List<Map> _carouselData = [];
  LatLng? userCoordinates;

  /// Builds a carousel from given [cards].
  Widget buildCarousel(List<Widget> cards) {
    return Container(
      height: 300,
      child: CustomCarousel(cards: cards),
    );
  }

  /// Builds a carousel with cards based on [selectedFilter].
  FutureBuilder<List<Widget>> buildFilteredCarousel(
      String selectedFilter, VoidCallback onTap) {
    return FutureBuilder(
        future: _selectFiltering(selectedFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  child: snapshot.data!.length == 0
                      ? Text('This list is empty.')
                      : CustomCarousel(cards: snapshot.data!));
            } else {
              return InkWell(
                onTap: onTap,
                child: Text("Error"),
              );
            }
          } else {
            return SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator());
          }
        });
  }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    for (int index = 0; index < docks.length; index++) {
      for (var station in docks) {
        _carouselData.add(
          {
            'station': station,
          },
        );
      }
    }
    _dockingStationCards = List<Widget>.generate(
        docks.length,
        (index) => DockingStationCard.station(
              _carouselData[index]["station"],
            ));

    return _dockingStationCards;
  }

  /// Calls a filtering method respective to [filter].
  Future<List<Widget>> _selectFiltering(String filter) async {
    if (filter == 'Favourites') {
      return _retrieve10FilteredFavouritesCards();
    }
    return _retrieve10FilteredByDistanceCards();
  }

  /// Retrieves 10 docks closest to [userCoordinates], filtered by distance.
  Future<List<Widget>> _retrieve10FilteredByDistanceCards() async {
    var docks = _stationManager.importStations().then((value) =>
        createDockingCards(
            _stationManager.get10ClosestDocks(userCoordinates!)));
    return docks;
  }

  /// Retrieves 10 docks closest to [userCoordinates], filtered by favourites.
  Future<List<Widget>> _retrieve10FilteredFavouritesCards() async {
    List<DockingStation> favourites = await FavouriteHelper.getUserFavourites();
    return createDockingCards(
        _stationManager.get10ClosestDocksFav(userCoordinates!, favourites));
  }
}
