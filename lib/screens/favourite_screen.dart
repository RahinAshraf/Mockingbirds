import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../widget/custom_carousel.dart';
import '../widget/docking_station_card.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late List<Widget> dockingStationCards;

  @override
  void initState() {
    super.initState();
    fetchDockingStations().whenComplete(() {
      setState(() {});
    });
  }

  Future<List<Widget>> fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = _stationManager
        .importStations()
        .then((value) => createDockingCards(_stationManager.stations));
    return list;
  }

  List<Widget> createDockingCards(List<DockingStation> docks) {
    List<Map> carouselData = [];

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
      print(index);
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

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Help'),
        ),
        body: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: CustomCarousel(cards: dockingStationCards),
            )
          ],
        ));
  }
}
