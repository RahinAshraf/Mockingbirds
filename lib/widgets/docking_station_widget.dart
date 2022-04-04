import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/widgets/docking_station_card.dart';

/// Creates a widget which displays the docking station card when a symbol is tapped.
/// Author: Hristina-Andreea Sararu k20036771
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
                        color: CustomColors.green,
                        size: 25,
                      ),
                      onPressed: () => setState(() => isVisible = false),
                    ),
                  ),
                ],
              ));
  }
}
