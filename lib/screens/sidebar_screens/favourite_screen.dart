import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import '../../providers/docking_station_manager.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<DockingStation> favourites = [];
  var _helper = FavouriteHelper(DatabaseManager());

  @override
  void initState() {
    _helper.getUserFavourites().then((data) {
      setState(() {
        favourites = data;
        print("lengthoflist" + favourites.length.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: favourites.isEmpty
          //TODO: MARIJA HRISTINA-> make prettier if you haven't added any fav
          ? const Center(child: Text("You haven't added any favourites."))
          : Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ListView.builder(
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  return DockingStationCard.station(favourites[index]);
                },
              ),
            ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
