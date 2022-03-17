import 'package:flutter/material.dart';
import '../services/favourite_service.dart';
import '../styles/styling.dart';
import '../models/docking_station.dart';
import '../widgets/docking_station_card.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin

//Loads cards of all of the users favourited docking station
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<DockingStation> favourites = [];
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
              child: Center(child: Text("You haven't added any favourites.")),
            )
          : Stack(
              children: [
                ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    return DockingStationCard(
                      favourites[index].stationId,
                      favourites[index].name,
                      favourites[index].numberOfBikes,
                      favourites[index].numberOfEmptyDocks,
                    );
                  },
                ),
              ],
            ),
      appBar: AppBar(
        title: const Text('My favourites'),
        backgroundColor: appBarColor,
      ),
    );
  }
}
