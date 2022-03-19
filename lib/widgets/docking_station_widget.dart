import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import '/models/docking_station.dart';

class DockStation extends StatefulWidget {
  DockStation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DockStationState();
  }
}

class DockStationState extends State<DockStation> {
  bool isVisible = false;
  DockingStation? station = null;

  void setData(DockingStation station, bool newVisible) {
    this.station;
    this.isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: station == null
            ? Container()
            : DockingStationCard.station(station!));
  }
}
