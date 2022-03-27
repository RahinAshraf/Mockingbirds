import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';

/// Class that sorts docking stations based on a specific filter.
///
/// This class fetches 10 closest stations from [DockingStationList]
/// based on given [userCoord]. It then displays the cards
/// and can be sorted based on options given in [_DockSorter.dropdownItems].
/// By default, cards are sorted by [_DockSorter.selectedFilter].
class DockSorter extends StatefulWidget {
  DockSorter(this.userCoord, {Key? key, required ScrollController controller})
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
  // List<String> dropdownItems = ['Distance', 'Favourites', 'Most Popular'];
  int setterDropdown = -1;
  String selectedFilter = 'Distance';

  @override
  void initState() {
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
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Icon(Icons.arrow_back_rounded, color: Colors.green),
              ),
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
          _dockingStations.build(selectedFilter),
        ],
      );
}
