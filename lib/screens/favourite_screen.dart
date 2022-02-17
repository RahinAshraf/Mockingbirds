import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/widget/station_carousel.dart';
import '../widget/custom_carousel.dart';
import '../widget/docking_station_card.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var allDocksCarousel =
      AllDocksCarousel(); //creates a carousel with all the docking station cards

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FutureBuilder<List<Widget>>(
          future: allDocksCarousel.retrieveAllCards(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: CustomCarousel(
                        cards: allDocksCarousel.dockingStationCards),
                  )
                ],
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
