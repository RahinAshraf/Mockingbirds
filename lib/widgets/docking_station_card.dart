import 'dart:async';
import 'package:flutter/material.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import '../helpers/database_helpers/database_manager.dart';

/// Creates a card for a docking station, to include its name, number of bikes and empty bikes.
/// Author: Tayyibah Uddin
/// Contributors: Fariha, Nicole, Hristina, Marija
class DockingStationCard extends StatefulWidget {
  late DockingStation dock;

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

    // Makes an API call using docking station ID to update information about the dock
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
      key: Key("dockCard"),
      elevation: 1.0,
      color: Colors.white,
      shadowColor: CustomColors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFaveButton(),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.dock.name,
                    style: CustomTextStyles.dockingStationCardNameStyle,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/logo.png"),
                            color: CustomColors.green,
                            size: 30,
                          ),
                          Text(
                            'Bikes: ${widget.dock.numberOfBikes.toString()}',
                            style: CustomTextStyles.dockingStationCardTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/dock.png"),
                            color: CustomColors.green,
                            size: 30,
                          ),
                          Text(
                            'Spaces: ${widget.dock.numberOfEmptyDocks.toString()}',
                            style: CustomTextStyles.dockingStationCardTextStyle,
                          ),
                        ],
                      ),
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

  /// Returns favourite button.
  IconButton _buildFaveButton() {
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

  /// Disables favourite button for 3 seconds after button click
  /// to prevent spamming the database.
  void _disableFavButton() {
    _isFavouriteButtonEnabled = false;
    Timer(const Duration(seconds: 3), () => _isFavouriteButtonEnabled = true);
  }
}
