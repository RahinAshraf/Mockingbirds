import 'package:flutter/material.dart';
import 'package:veloplan/widgets/docks/docking_stations_list.dart';

class Favourite extends StatefulWidget {
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var _dockingStationList =
      DockingStationList(); //retrieves all of the docking station cards

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: _dockingStationList.build(),
      appBar: AppBar(
        title: const Text('My favourites'),
      ),
    );
  }
}
