import 'package:flutter/material.dart';
import '/models/favourite.dart';
import '/helpers/favourite_helper.dart';
import 'favourite_button.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.

class dockingStationCard extends StatefulWidget {
  late String id;
  late String name;
  late String nb_bikes;
  late String nb_empty_docks;

  dockingStationCard(
    this.id,
    this.name,
    this.nb_bikes,
    this.nb_empty_docks,
  );

//I have commented this for now but if you want to make a card by just passing a station:
  // dockingStationCard.station(DockingStation station) {
  //   this.id = station.id;
  //   this.name = station.name;
  //   this.nb_bikes = station.nb_bikes.toString();
  //   this.nb_empty_docks = station.nb_empty_docks.toString();
  // }

  _dockingStationCardState createState() => _dockingStationCardState();
}

class _dockingStationCardState extends State<dockingStationCard> {
  var helper = FavouriteHelper(); //change name
  List<FavouriteDockingStation> favourites = [];

  late Icon favIcon;

  @override
  void initState() {
    FavouriteHelper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: helper.isFavouriteStation(widget.id, favourites)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
              onPressed: () async {
                List<FavouriteDockingStation> updatedFavourites =
                    await FavouriteHelper.getUserFavourites();
                helper.toggleFavourite(
                  widget.id,
                  widget.name,
                  widget.nb_bikes,
                  widget.nb_empty_docks,
                );

                setState(() {
                  favourites = updatedFavourites;
                });
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Text('Total bikes: ${widget.nb_bikes}'),
                  Text('Available bikes: ${widget.nb_empty_docks}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
