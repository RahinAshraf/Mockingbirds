import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station_detail.dart';
import 'package:veloplan/services/favourite_service.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:collection/collection.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var _dockingStationCarousel =
      dockingStationCarousel(); //retrieves all of the docking station cards

  late List<FavouriteDockingStation> favourites;

  var helper = FirestoreHelper();

  @override
  void initState() {
    FirestoreHelper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
        //print(checkDis());
        //helper.toggleFavourite("pls?");
      });
    });
    super.initState();
  }

  // bool isFavouriteStation(String stationId) {
  //   //checks if the station id is in the list of faves.
  //   FavouriteDockingStation? fave = favourites.firstWhereOrNull(
  //       (FavouriteDockingStation f) => (f.stationId == stationId));
  //   if (fave == null) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  // toggleFavourite(String stationId) async {
  //   FirestoreHelper helper = FirestoreHelper();
  //   if (isFavouriteStation(stationId)) {
  //     //refactor this:
  //     FavouriteDockingStation fave = favourites.firstWhere(
  //         (FavouriteDockingStation f) => (f.stationId == stationId));
  //     String favId = fave.id;
  //     await helper.deleteFavourite(favId);
  //   } else {
  //     await helper.addFavourite(stationId);
  //   }
  //   List<FavouriteDockingStation> updatedFavourites =
  //       await FirestoreHelper.getUserFavourites();
  //   setState(() {
  //     favourites = updatedFavourites;
  //   });
  // }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Stack(
        children: [
          _dockingStationCarousel.buildCarousel(),
          Container(
              alignment: Alignment(0, 0),
              child: FloatingActionButton(onPressed: () {
                if (favourites.isEmpty) {
                  print("no faves");
                } else {
                  print("yes!");
                }
              }))
        ],
      ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
