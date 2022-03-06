import '../widgets/docks/docking_stations_list.dart';
import 'package:flutter/material.dart';

class DockSorter extends StatefulWidget {
  const DockSorter({required ScrollController controller});

  @override
  _DockSorter createState() => _DockSorter();
}

class _DockSorter extends State<DockSorter> {
  ScrollController controller = ScrollController();

  var _dockingStationCarousel =
      DockingStationList(); //retrieves all of the docking station cards

  String selectedFilter = "Distance";

  @override
  Widget build(BuildContext context) => ListView(
        children: [
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
                items: ['Distance', 'Favourites', 'Most Popular', 'Suggestions']
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
