import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/widgets/carousel/station_carousel.dart';
import '../screens/journey_planner_screen.dart';
import 'package:flutter/material.dart';

class DockSorter extends StatefulWidget {
  late final LatLng userCoord;
  DockSorter(this.userCoord, {Key? key, required ScrollController controller})
      : super(key: key);

  @override
  _DockSorter createState() => _DockSorter();
}

class _DockSorter extends State<DockSorter> {
  ScrollController controller = ScrollController();
  late LatLng userCoordinates;
  late var _dockingStationCarousel;

  @override
  void initState() {
    // TODO: implement initState
    userCoordinates = super.widget.userCoord;
    super.initState();
    _dockingStationCarousel = dockingStationCarousel(userCoordinates);
  }

  String selectedFilter = "Distance";

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_rounded),
          ),
          Row(
            children: [
              const Text("Sort by: "),
              const SizedBox(width: 10.0),
              DropdownButton(
                enableFeedback: true,
                underline: Container(
                  height: 1,
                  color: Colors.green,
                ),
                elevation: 16,
                iconDisabledColor: Colors.black,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
                value: selectedFilter,
                items: ['Distance', 'Favourites', 'Most Popular']
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
              const SizedBox(width: 160.0),
              Tooltip(
                message:
                    'Here, you can sort your docking stations based on some filter.',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFFb6e59e),
                ),
                height: 50,
                padding: const EdgeInsets.all(8.0),
                preferBelow: false,
                textStyle: const TextStyle(
                  fontSize: 12,
                ),
                showDuration: const Duration(seconds: 2),
                waitDuration: const Duration(seconds: 1),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider(),
          _dockingStationCarousel.build(),
        ],
      );
}
