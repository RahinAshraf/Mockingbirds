import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:veloplan/widgets/docking_station_card.dart';
import '/models/docking_station.dart';

///Author: Hristina
///
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

  void setData(DockingStation station, bool isVisible) {
    //setState(() {
    this.station = station;
    this.isVisible = isVisible;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: station == null
            ? Container()
            : Stack(
                children: [
                  DockingStationCard.station(station!),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFF99D2A9),
                        size: 25,
                      ),
                      onPressed: () => setState(() => isVisible = false),
                    ),
                  ),
                ],
              ));
  }
}
