import 'dart:async';
import 'package:flutter/material.dart';
import '../helpers/database_helpers/favourite_helper.dart';
import '../models/docking_station.dart';
import '../providers/docking_station_manager.dart';
import '../helpers/database_helpers/database_manager.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.
///Author: Tayyibah Uddin
///Contributor(s): Fariha Choudhury, Nicole Lehchevska, Hristina-Andreea Sararu

class DockingStationCard extends StatefulWidget {
  late DockingStation dock;

  DockingStationCard();

  ///Create an instance of a card by passing in a DockingStation
  DockingStationCard.station(DockingStation station) {
    this.dock = station;
  }

  @override
  _DockingStationCardState createState() => _DockingStationCardState();
}

class _DockingStationCardState extends State<DockingStationCard> {
  final _helper = FavouriteHelper(DatabaseManager());
  List<DockingStation> _favourites = [];
  bool _isFavouriteButtonEnabled = true;
  var _manager = dockingStationManager();

  @override
  void initState() {
    _helper.getUserFavourites().then((data) {
      if (mounted)
        setState(() {
          _favourites = data;
        });
    });

    //Makes an API call using docking station ID to update information about the dock
    _manager.checkStation(widget.dock).then((value) {
      if (mounted)
        setState(() {
          widget.dock.assign(value);
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
                    widget.dock.name,
                    style: const TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF99D2A9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            ImageIcon(
                              AssetImage("assets/images/logo.png"),
                              color: Color(0xFF99D2A9),
                              size: 30,
                            ),
                            Text(
                              'Bikes: ${widget.dock.numberOfBikes.toString()}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF99D2A9),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ]),
                      Column(children: [
                        Row(
                          children: [
                            ImageIcon(
                              AssetImage("assets/images/dock.png"),
                              color: Color(0xFF99D2A9),
                              size: 30,
                            ),
                            Text(
                              'Spaces: ${widget.dock.numberOfEmptyDocks.toString()}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF99D2A9),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ]),
                    ],
                  ),
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
      icon: getFaveButtonColours(),
      onPressed: () async {
        if (_isFavouriteButtonEnabled) {
          _disableFavButton();

          _helper.toggleFavourite(
              widget.dock.stationId, await _helper.getUserFavourites());

          List<DockingStation> updatedFavourites =
              await _helper.getUserFavourites();
          setState(() {
            _favourites = updatedFavourites;
          });
        }
      },
    );
  }

  Icon getFaveButtonColours() {
    return Icon(
      Icons.favorite,
      color: _helper.isFavouriteStation(widget.dock.stationId, _favourites)
          ? Color.fromARGB(255, 214, 93, 77)
          : Colors.grey,
    );
  }

  ///Disables favourite button for 3 seconds after button click
  ///to prevent spamming the database
  void _disableFavButton() {
    _isFavouriteButtonEnabled = false;
    Timer(const Duration(seconds: 3), () => _isFavouriteButtonEnabled = true);
  }
}
