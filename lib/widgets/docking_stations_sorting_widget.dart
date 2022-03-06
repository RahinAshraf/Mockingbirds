import 'package:flutter/material.dart';
import '../widgets/docks/docking_stations_list.dart';

class DockSorter extends StatefulWidget {
  const DockSorter({required ScrollController controller});

  @override
  _DockSorter createState() => _DockSorter();
}

class _DockSorter extends State<DockSorter> {
  ScrollController controller = ScrollController();

  var _dockingStationCarousel =
      DockingStationList(); //retrieves all of the docking station cards

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Distance"), value: "Distance"),
      DropdownMenuItem(child: Text("Favourites"), value: "Favourites"),
      DropdownMenuItem(child: Text("Most Popular"), value: "Most Popular"),
      DropdownMenuItem(child: Text("Suggestions"), value: "Suggestions"),
    ];
    return menuItems;
  }

  String selectedValue = "Distance";

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Row(
            children: [
              Text("Sort by"),
              SizedBox(width: 10.0),
              DropdownButton(
                value: selectedValue,
                items: dropdownItems,
                onChanged: (String? value) {
                  // setState(() {
                  // });
                },
              ),
              Tooltip(
                message:
                    'Here, you can sort your docking stations based on some filter.',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                      colors: <Color>[Color(0x80b6e59e), Colors.white]),
                ),
                height: 50,
                padding: const EdgeInsets.all(8.0),
                preferBelow: false,
                textStyle: const TextStyle(
                  fontSize: 24,
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
          Divider(),
          _dockingStationCarousel.build(),
        ],
      );
}
