import 'package:latlong2/latlong.dart' as cords;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';

/// Class that sorts docking stations based on a specific filter.
///
/// This class fetches 10 closest stations from [DockingStationList]
/// based on given [userCoord]. It then displays the cards
/// and can be sorted based on options given in [_DockSorter.dropdownItems].
/// By default, cards are sorted by [_DockSorter.selectedFilter].

class DockSorter extends StatefulWidget {
  DockingStation ds1 =
      DockingStation("ds1ID", "ds1", true, true, 10, 11, 12, 15.6, 89.0);
  DockingStation ds2 =
      DockingStation("ds2ID", "ds2", true, true, 20, 21, 22, 15.6, 99.1);
  DockingStation ds3 =
      DockingStation("ds3ID", "ds3", true, true, 30, 31, 32, 15.6, 89.0);
  DockingStation ds4 =
      DockingStation("ds4ID", "ds4", true, true, 40, 41, 42, 15.6, 89.0);
  DockingStation ds5 =
      DockingStation("ds5ID", "ds5", true, true, 50, 51, 52, 15.6, 89.0);
  DockingStation ds6 =
      DockingStation("ds6ID", "ds6", true, true, 60, 61, 62, 15.6, 89.0);

  final DockingStation? selectedDockStation;

  DockSorter(this.userCoord,
      {Key? key,
      required ScrollController controller,
      required this.selectedDockStation})
      : super(key: key);

  late final LatLng userCoord;

  @override
  _DockSorter createState() => _DockSorter();
}

class _DockSorter extends State<DockSorter> {
  ScrollController controller = ScrollController();
  late LatLng userCoordinates;
  late DockingStationCarousel _dockingStations;
  List<String> dropdownItems = ['Distance', 'Favourites', 'Most Popular'];
  String selectedFilter = 'Distance';
  cords.LatLng? selectedDockStation;

  @override
  void initState() {
    selectedDockStation = cords.LatLng(widget.selectedDockStation?.lat ?? 0,
        widget.selectedDockStation?.lon ?? 0);

    userCoordinates = super.widget.userCoord;
    super.initState();
    _dockingStations = DockingStationCarousel(userCoordinates);
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TextButton(
              //   onPressed: () {
              //     //Navigator.pop(context, widget.selectedDockStation); //put what you want to send back to jp here instead of " widget.selectedDockStation"
              //     Navigator.pop(context, widget.ds2);
              //     //Navigator.pop(context, soft-coded-dock);

              //   },
              //   child:
              //       const Icon(Icons.arrow_back_rounded, color: Colors.green),
              // ),
              Row(
                children: [
                  const Text("Sort by: "),
                  const SizedBox(width: 10),
                  DropdownButton(
                    enableFeedback: true,
                    underline: Container(height: 1, color: Colors.green),
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                    value: selectedFilter,
                    items: dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newFilter) {
                      setState(() {
                        selectedFilter = newFilter!;
                        // TODO: reload sorted docks based on selected filter
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Divider(),
          ),
          _dockingStations.build(),
        ],
      );
}
