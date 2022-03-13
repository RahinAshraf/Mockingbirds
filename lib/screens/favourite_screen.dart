import 'package:flutter/material.dart';
import 'package:veloplan/helpers/favourite_helper.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import 'package:veloplan/models/favourite.dart';

//Loads cards of all of the users favourited docking station
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
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
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
        //    backgroundColor: primaryColor,
      ),
    );
  }
}
