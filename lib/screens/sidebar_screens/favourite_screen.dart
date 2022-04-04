import 'package:flutter/material.dart';
import '../../helpers/database_helpers/database_manager.dart';
import '../../helpers/database_helpers/favourite_helper.dart';
import '../../models/docking_station.dart';
import '../../screens/splash_screen.dart';
import '../../widgets/docking_station_card.dart';

///Loads users favourited docking stations and displays them in a list view.
///Author: Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late List<DockingStation> _favourites;
  var _helper = FavouriteHelper(DatabaseManager());

  @override
  void initState() {
    super.initState();
  }

  Future<List<DockingStation>> setFavourites() async {
    this._favourites = await _helper.getUserFavourites();
    return _favourites;
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FutureBuilder<List<DockingStation>>(
        future: setFavourites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen(); //replace with our splash screen

          }
          return _favourites.isEmpty
              ? const Center(child: Text("You haven't added any favourites."))
              : Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListView.builder(
                    itemCount: _favourites.length,
                    itemBuilder: (context, index) {
                      return DockingStationCard.station(_favourites[index]);
                    },
                  ),
                );
        },
      ),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
