import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station_detail.dart';
import 'package:veloplan/services/favourite_service.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
import 'package:veloplan/models/favourite.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var _dockingStationCarousel =
      dockingStationCarousel(); //retrieves all of the docking station cards

  late List<FavouriteDockingStation> favourites;

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
      body: _dockingStationCarousel.buildCarousel(),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
