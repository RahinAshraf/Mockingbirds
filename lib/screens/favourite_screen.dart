import 'package:flutter/material.dart';
import 'package:veloplan/services/favourite_service.dart';
import 'package:veloplan/widgets/carousel/docking_station_card.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:collection/collection.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var _dockingStationCarousel =
      dockingStationCarousel(); //retrieves all of the docking station cards

  List<FavouriteDockingStation> favourites = [];

  var helper = FirestoreHelper();

  @override
  void initState() {
    FirestoreHelper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body:
          // favourites.isEmpty
          // ? SizedBox(
          //     height: MediaQuery.of(context).size.height / 1.3,
          //     child: Center(
          //       child: Text("You haven't added any favourites."),
          //     ),
          //   )
          // :
          Stack(
        children: [
          ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return dockingStationCard(
                  favourites[index].stationId,
                  favourites[index].name,
                  favourites[index].nb_bikes,
                  favourites[index].nb_empty_docks,
                );
              })
          //_dockingStationCarousel.buildCarousel(),
        ],
      ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
