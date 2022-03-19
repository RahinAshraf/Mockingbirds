import 'dart:async';
import 'package:flutter/material.dart';
import '/models/docking_station.dart';
import '/services/favourite_service.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
///Author: Tayyibah Uddin
///Contributor: Fariha Choudhury

class DockingStationCard extends StatefulWidget {
  late final String iD;
  late final String stationName;
  late final int numberOfBikes;
  late final int numberOfEmptyDocks;

  DockingStationCard(
    this.iD,
    this.stationName,
    this.numberOfBikes,
    this.numberOfEmptyDocks,
  );

//I have commented this for now but if you want to make a card by just passing a station:
  // dockingStationCard.station(DockingStation station) {
  //   this.iD = station.iD;
  //   this.stationName = station.stationName;
  //   this.numberOfBikes = station.numberOfBikes.toString();
  //   this.numberOfEmptyDocks = station.numberOfEmptyDocks.toString();

  DockingStationCard.station(DockingStation station) {
    iD = station.stationId;
    stationName = station.name;
    numberOfBikes = station.numberOfBikes;
    numberOfEmptyDocks = station.numberOfEmptyDocks;
    //print(this.iD);
  }

  @override
  _DockingStationCardState createState() => _DockingStationCardState();
}

class _DockingStationCardState extends State<DockingStationCard> {
  final _helper = FavouriteHelper(); //change name
  List<DockingStation> _favourites = [];
  bool isFavouriteEnabled = true;

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        _favourites = data;
      });
    });
    super.initState();
  }

  ///Sets [isFavouriteEnabled] to false to disable favourite button for 3 seconds after button click
  void _disableFavButton() {
    isFavouriteEnabled = false;
    Timer(Duration(seconds: 3), () => isFavouriteEnabled = true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.green[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: _helper.isFavouriteStation(widget.iD, _favourites)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
              onPressed: () async {
                if (isFavouriteEnabled) {
                  _disableFavButton();
                  List<DockingStation> updatedFavourites =
                      await FavouriteHelper.getUserFavourites();
                  _helper.toggleFavourite(
                    widget.iD,
                    widget.stationName,
                    widget.numberOfBikes,
                    widget.numberOfEmptyDocks,
                  );

                  setState(() {
                    _favourites = updatedFavourites;
                  });
                }
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Text('Total bikes: ${widget.numberOfBikes.toString()}'),
                  Text(
                      'Available bikes: ${widget.numberOfEmptyDocks.toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
