import 'dart:async';
import 'package:flutter/material.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';

/// Creates a card for a docking station, to include its name, number of bikes and empty bikes.
/// Author: Tayyibah Uddin
/// Contributor: Fariha Choudhury, Nicole Lehchevska, Hristina-Andreea Sararu
class DockingStationCard extends StatefulWidget {
  late DockingStation dockTemp;

  DockingStationCard.station(DockingStation station) {
    this.dockTemp = station;
  }

  @override
  _DockingStationCardState createState() => _DockingStationCardState();
}

class _DockingStationCardState extends State<DockingStationCard> {
  final _helper = FavouriteHelper();
  var _manager = dockingStationManager();
  List<DockingStation> _favourites = [];
  bool _isFavouriteButtonEnabled = true;
  bool _isFavourited = false;

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      if (mounted)
        setState(() {
          _favourites = data;
          _isFavourited = _helper.isFavouriteStation(
              widget.dockTemp.stationId, _favourites);
        });
    });

    // makes an API call with dock id and updates the info about the dock
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
                    widget.dockTemp.name,
                    style: CustomTextStyles.dockingStationCardNameStyle,
                  ),
                  Divider(
                    color: CustomColors.green,
                    thickness: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/dock.png"),
                            color: CustomColors.green,
                            size: 30,
                          ),
                          Text(
                            'Bikes: ${widget.dockTemp.numberOfBikes.toString()}',
                            style: CustomTextStyles.dockingStationCardTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/logo.png"),
                            color: CustomColors.green,
                            size: 30,
                          ),
                          Text(
                            'Spaces: ${widget.dockTemp.numberOfEmptyDocks.toString()}',
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

  IconButton _buildFaveButton() {
    return IconButton(
      icon: _getFaveButton(),
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

  Icon _getFaveButton() {
    return Icon(
      Icons.favorite,
      color: _isFavourited ? Colors.red : Colors.grey,
    );
  }

  /// Disables favourite button for 3 seconds after button click
  /// to prevent spamming the database.
  void _disableFavButton() {
    _isFavouriteButtonEnabled = false;
    Timer(const Duration(seconds: 3), () => _isFavouriteButtonEnabled = true);
  }
}
