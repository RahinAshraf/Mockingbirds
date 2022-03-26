import 'dart:async';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
///A card can be favourited.
///Author: Tayyibah
///Contributor: Fariha
class DockingStationCard extends StatefulWidget {
  // late final String iD;
  // late final String stationName;
  // late final int numberOfBikes;
  // late final int numberOfEmptyDocks;
  late DockingStation dockTemp;

  DockingStationCard(
      // this.iD,
      // this.stationName,
      // this.numberOfBikes,
      // this.numberOfEmptyDocks,
      );

//I have commented this for now but if you want to make a card by just passing a station:
  DockingStationCard.station(DockingStation station) {
    this.dockTemp = station;
    // this.iD = station.stationId;
    // this.stationName = station.name;
    // this.numberOfBikes = station.numberOfBikes;
    // this.numberOfEmptyDocks = station.numberOfEmptyDocks;
  }

  @override
  _DockingStationCardState createState() => _DockingStationCardState();
}

class _DockingStationCardState extends State<DockingStationCard> {
  final _helper = FavouriteHelper(); //change name
  List<DockingStation> _favourites = [];
  bool _isFavouriteButtonEnabled = true;
  bool _isFavourited = false;
  var _manager = dockingStationManager();

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        _favourites = data;
        _isFavourited =
            _helper.isFavouriteStation(widget.dockTemp.stationId, _favourites);
      });
    });
    //method that makes an api call with dock id
    //dock objec numb
    _manager.checkStation(widget.dockTemp).then((value) {
      if (mounted)
        setState(() {
          widget.dockTemp.assign(value);
        });
    });
    super.initState();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFaveButton(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.dockTemp.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  if (widget.dockTemp.numberOfBikes != null)
                    Text(
                        'Total bikes: ${widget.dockTemp.numberOfBikes.toString()}'),
                  if (widget.dockTemp.numberOfEmptyDocks != null)
                    Text(
                        'Available bikes: ${widget.dockTemp.numberOfEmptyDocks.toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildFaveButton() {
    return IconButton(
      icon: getFaveButton(),
      onPressed: () async {
        if (_isFavouriteButtonEnabled) {
          _disableFavButton();

          _helper.toggleFavourite(
            widget.dockTemp.stationId,
            widget.dockTemp.name,
          );

          List<DockingStation> updatedFavourites =
              await FavouriteHelper.getUserFavourites();
          setState(() {
            _favourites = updatedFavourites;
            _isFavourited = !_isFavourited;
          });
        }
      },
    );
  }

  Icon getFaveButton() {
    return Icon(
      Icons.favorite,
      color: _isFavourited ? Colors.red : Colors.grey,
    );
  }

  ///Disables favourite button for 3 seconds after button click
  ///to prevent spamming the database
  void _disableFavButton() {
    _isFavouriteButtonEnabled = false;
    Timer(const Duration(seconds: 3), () => _isFavouriteButtonEnabled = true);
  }
}
