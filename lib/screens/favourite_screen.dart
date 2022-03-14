import 'package:flutter/material.dart';
import 'package:veloplan/services/favourite_service.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import 'package:veloplan/models/favourite.dart';
import '../styles/styling.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<FavouriteDockingStation> favourites = [];
  var helper = FavouriteHelper();

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
  Widget build(BuildContext build) {
    return Scaffold(
      body: favourites.isEmpty
          ? const SafeArea(
              //height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                //add constants
                child: Text("You haven't added any favourites."),
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return dockingStationCard(
                        favourites[index].station_id,
                        favourites[index].name,
                        favourites[index].nb_bikes,
                        favourites[index].nb_empty_docks,
                      );
                    }),
              ],
            ),
      appBar: AppBar(
        title: const Text('My favourites'),
        backgroundColor: appBarColor,
      ),
    );
  }
}
