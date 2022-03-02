import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import '/models/favourite.dart';
import '/services/favourite_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloplan/models/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Creates a card for a docking station, to include its name, number of bikes and empty bikes.

class dockingStationCard extends StatefulWidget {
  // final int index;
  // final DockingStation station;
  late String id;
  late String name;
  late String nb_bikes;
  late String nb_empty_docks;

  dockingStationCard(
    // this.index,
    // this.station,
    this.id,
    this.name,
    this.nb_bikes,
    this.nb_empty_docks,
  );

  // dockingStationCard.station(DockingStation station) {
  //   this.id = station.id;
  //   this.name = station.name;
  //   this.nb_bikes = station.nb_bikes.toString();
  //   this.nb_empty_docks = station.nb_empty_docks.toString();
  // }

  _dockingStationCardState createState() => _dockingStationCardState();
}

class _dockingStationCardState extends State<dockingStationCard> {
  var helper = FirestoreHelper(); //change name
  List<FavouriteDockingStation> favourites = [];

  late Icon favIcon;

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
  Widget build(BuildContext context) {
    return Card(
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
                    await FirestoreHelper.getUserFavourites();
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
                  Text(widget.name),
                  Text('Bike no: ${widget.nb_bikes}'),
                  Text('Empty: ${widget.nb_empty_docks}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
