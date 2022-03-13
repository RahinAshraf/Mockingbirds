import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:veloplan/widget/carousel/docking_station_card.dart';

class DockStation extends StatefulWidget {
  DockStation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DockStationState();
  }
}

class DockStationState extends State<DockStation> {
  bool isVisible = false;
  LatLng latLng = getLatLngFromSharedPrefs();
  int index = 0;
  late String name = 'Place holder';
  late String nb_bikes = '0';
  late String nb_empty_docks = '0';

  void setVisible(bool newVisible) {
    isVisible = newVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: dockingStationCard(index, name, nb_bikes, nb_empty_docks));
  }
}
