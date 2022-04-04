import 'package:flutter/material.dart';
import '../../helpers/database_helpers/database_manager.dart';
import '../../helpers/database_helpers/favourite_helper.dart';
import '../../models/docking_station.dart';
import '../../screens/splash_screen.dart';
import '../../widgets/docking_station_card.dart';
import '../../styles/styling.dart';

///Loads users favourited docking stations and displays them in a list view.
///Author: Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late List<DockingStation> _favourites;
  var _favouriteHelper = FavouriteHelper(DatabaseManager());

  @override
  void initState() {
    super.initState();
  }

  Future<List<DockingStation>> setFavourites() async {
    this._favourites = await _favouriteHelper.getUserFavourites();
    return _favourites;
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FutureBuilder<List<DockingStation>>(
        future: setFavourites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen();
          }
          return _favourites.isEmpty
              ? Center(
                  key: Key("noFavourites"),
                  child: Column(children: [
                    SizedBox(height: 100),
                    Image.asset('assets/images/favourites_sidebar.png',
                        width: 170, height: 170),
                    SizedBox(height: 40),
                    Text(
                      "You haven't added any favourites yet.",
                      style: sidebarTextStyle,
                    )
                  ]))
              : Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListView.builder(
                    key: Key("allFavourites"),
                    itemCount: _favourites.length,
                    itemBuilder: (context, index) {
                      return DockingStationCard.station(_favourites[index]);
                    },
                  ),
                );
        },
      ),
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('My favourites'),
      ),
    );
  }
}
