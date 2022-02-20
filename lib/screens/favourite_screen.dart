import 'package:flutter/material.dart';
import 'package:veloplan/widget/carousel/station_carousel.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var _dockingStationCarousel =
      dockingStationCarousel(); //retrieves all of the docking station cards

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: _dockingStationCarousel.buildCarousel(build),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
