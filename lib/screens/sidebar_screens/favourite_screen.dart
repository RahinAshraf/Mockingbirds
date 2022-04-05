import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/favourite_helper.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/screens/splash_screen.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

/// Loads user's favourites and displays them in a list view.
/// Author: Tayyibah Uddin
class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  late List<DockingStation> _favourites;
  FavouriteHelper _favouriteHelper = FavouriteHelper(DatabaseManager());

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
              ? Column(
                  key: Key("noFavourites"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Image.asset('assets/images/favourites_sidebar.png',
                          width: 140, height: 140),
                      SizedBox(height: 10),
                      Text(
                        "You haven't added any favourites yet.",
                        style: CustomTextStyles.sidebarTextStyle,
                        textAlign: TextAlign.center,
                      )
                    ])
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
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
      backgroundColor: CustomColors.whiteReplacement,
    );
  }
}
