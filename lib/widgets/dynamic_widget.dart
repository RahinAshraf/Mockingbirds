import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget.dart';
import '../helpers/live_location_helper.dart';
import '../models/docking_station.dart';
import '../providers/docking_station_manager.dart';
import '../providers/location_service.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
as LatLong;

import '../screens/dock_sorter_screen.dart';

/*
 The widgets the user dynamically creates during runtime, for them to specify the locations of the journey.
 Each dynamic widget is a row which comes with a row of children:
    - red cross, to delete a location from the journey planner list
    - TextField , to insert a location to the journey planner list
    - green > icon, to allow users to specify specific docks (if they wish) of the locations user specifies in the TextField
 */

class DynamicWidget extends StatelessWidget {
  final TextEditingController placeTextController = TextEditingController();
  final TextEditingController editDockTextEditController =
  TextEditingController();
  List<List<double?>?>? selectedCoords;
  Function(int)? onDelete;
  int position = -1;
  final locationService = LocationService();
  final Map? coordDataMap;
  // final dockingStationManager _stationManager = dockingStationManager();

  //setter for the position index
  void setIndex(index) {
    position = index;
  }

  @override
  void initState() {
    //importDockStation();
    placeTextController.addListener(() {
      checkInputLocation();
    });
  }

  // void importDockStation() async {
  //   await _stationManager.importStations();
  //   print(_stationManager.stations.length.toString() + "this is the length of the stationManager");
  // }

  DynamicWidget({Key? key, required this.selectedCoords, this.coordDataMap})
      : super(key: key);

  void checkInputLocation() async {
    print("THIS IS CLOSET DOCK");
    if (placeTextController.text.isEmpty) {
      print("Nothing specified");
    } else {
      print("REACHED METHOD GETCLOSETDOCK");
      List coordPlace = await locationService.getPlaceCoords(
          placeTextController.text); //getting coord of the place [lat,lng]
      getClosetDock(coordPlace.first, coordPlace.last);
      //TO-DO
      // - change to get closet dock with available bikes after getting num of cyclist
    }
  }

  void getClosetDock(double? lat, double? lng) async {
    // List coordPlace = await locationService.getPlaceCoords(placeTextController.text); //getting coord of the place [lat,lng]
    LatLong.LatLng latlngPlace = LatLong.LatLng(lat!, lng!); //coverting list to latlng
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    print(latlngPlace);
    DockingStation closetDock = _stationManager.getClosestDock(latlngPlace);
    print("closet dock ${closetDock.name}");
    editDockTextEditController.text = closetDock.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //const SizedBox(height: 17),
              //Expanded(
              TextButton(
                onPressed: () {
                  int len = selectedCoords?.length ?? 0;
                  if (position < len) {
                    selectedCoords?.removeAt(position);
                  }
                  onDelete?.call(position);
                },
                child: const Icon(
                  Icons.close_outlined,
                  size: 35,
                  color: Colors.red,
                ),
              ),
              //),
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    // onChanged: (placeTextController) { //called when you type
                    //   print("ONCHANGED");
                    //   checkInputLocation();
                    // },
                    onEditingComplete: () {
                      print("ONCHANGED");
                      checkInputLocation();
                    },
                    readOnly: true,
                    onTap: () {
                      _handleSearchClick(context, position);
                    },
                    controller: placeTextController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (coordDataMap == null) return;
                          _useCurrentLocationButtonHandler(
                              coordDataMap!, placeTextController);
                        },
                        icon: const Icon(
                          Icons.my_location,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      suffixIconColor: Colors.blue,
                      hintText: 'Where to?',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Icon(Icons.menu),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.subdirectory_arrow_right),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(),
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Text("Default closest dock"),
            // ),
            Expanded(
              child: TextField(
                enabled: false,
                controller: editDockTextEditController,
                decoration: InputDecoration(
                  hintText: "Default closest dock",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  List temp = await locationService
                      .getPlaceCoords(placeTextController.text);
                  checkInputLocation();
                  //LatLng locationInLatLng = LatLng(temp.first, temp.last);
                  //print(locationInLatLng);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DockSorterScreen(_latLng(temp.first, temp.last))));
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.navigate_next_outlined,
                )),
          ],
        ),
      ],
    );
  }

  LatLong.LatLng _latLng(double lat, double lng) => LatLong.LatLng(lat, lng);

  //Executed when the user presses on a search TextField
  void _handleSearchClick(BuildContext context, int position) async {
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $position");
    final feature = result as Feature?;
    if (feature != null) {
      final len = selectedCoords?.length ?? 0;
      placeTextController.text = feature.placeName ?? "N/A";

      if (position > ((selectedCoords?.length) ?? 0) - 1 ||
          (selectedCoords?.isEmpty ?? true)) {
        selectedCoords?.add(feature.geometry?.coordinates);
      } else {
        selectedCoords?[position] = feature.geometry?.coordinates;
      }
      getClosetDock(feature.geometry?.coordinates.first,
          feature.geometry?.coordinates.last);
    }
    print("RESULT => $result");
  }

  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }

  //When called, this function sets the first location of the journey to the users current location
  _useCurrentLocationButtonHandler(
      Map response, TextEditingController controller) async {
    sharedPreferences.setString('source', json.encode(response));
    String place = response['place'];
    double latitudeOfPlace = response['location'].latitude;
    double longitudeOfPlace = response['location'].longitude;
    List<double?> currentLocationCoords = [latitudeOfPlace, longitudeOfPlace];
    controller.text = place;

    checkInputLocation();

    if (position > ((selectedCoords?.length) ?? 0) - 1 ||
        (selectedCoords?.isEmpty ?? true)) {
      selectedCoords?.add(currentLocationCoords);
    } else {
      selectedCoords?[position] = currentLocationCoords;
    }
  }
}
