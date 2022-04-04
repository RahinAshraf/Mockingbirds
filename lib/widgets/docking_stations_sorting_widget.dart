import 'package:latlong2/latlong.dart' as cords;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';

/// Sorts docking stations based on a specific filter.
///
/// This class fetches 10 closest stations to [userCoord] from
/// [DockingStationCarousel]. It then displays the cards
/// and can be sorted based on options given in [_DockSorter.dropdownItems].
/// By default, cards are sorted by [_DockSorter.selectedFilter].

class DockSorter extends StatefulWidget {
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
  List<String> dropdownItems = ['Distance', 'Favourites'];
  int setterDropdown = -1;
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
              // !  remove?
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_rounded,
                    key: Key("back"), color: Colors.green),
              ),
              //!
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
                        buildCarousel(newFilter);
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
          buildCarousel(selectedFilter)
          // _dockingStations.build(selectedFilter),
        ],
      );

  FutureBuilder<List> buildCarousel(var newSelectedFilter) {
    var dockSt = DockingStationCarousel(userCoordinates);
    return dockSt.build(newSelectedFilter);
  }
}
