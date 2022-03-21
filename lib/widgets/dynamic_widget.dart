import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';
import '../helpers/live_location_helper.dart';
import '../providers/location_service.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;

///The widgets the user dynamically creates during runtime, for them to specify the locations of the journey.
///Each dynamic widget has the following properties:
/// - red cross, to delete a location from the journey planner list
/// - TextField , which redirects the user to PlaceSearchScreen to insert a location to the journey planner list
/// - menu item icon, to indicate to the user that the list is reorderable via dragging
///@author: Rahin Ashraf - k20034059

class DynamicWidget extends StatelessWidget {
  final TextEditingController placeTextController = TextEditingController();
  final TextEditingController editDockTextEditController =
      TextEditingController();
  List<List<double?>?>? selectedCoords;
  Function(int)? onDelete;
  int position = -1;
  final locationService = LocationService();
  final Map? coordDataMap;

  ///set the position of the selected coordinates list to the passed in index
  void setIndex(index) {
    position = index;
  }

  ///listen to changes for user input on the location specified in the location textfield
  @override
  void initState() {
    placeTextController.addListener(() {
      PanelExtensions.of()
          .checkInputLocation(placeTextController, editDockTextEditController);
    });
  }

  DynamicWidget({Key? key, required this.selectedCoords, this.coordDataMap})
      : super(key: key);
  late DockingStation closetDockStation;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
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
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    onEditingComplete: () {
                      print("ONCHANGED");
                      PanelExtensions.of(context: context).checkInputLocation(
                          placeTextController, editDockTextEditController);
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
                      focusedBorder: circularInputBorder(),
                      border: circularInputBorder(),
                      enabledBorder: circularInputBorder(),
                      disabledBorder: circularInputBorder(),
                      errorBorder: circularInputBorder(),
                      focusedErrorBorder: circularInputBorder(),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.menu),
            ],
          ),
        ),
        PanelExtensions(context: context).buildDefaultClosestDock(
            editDockTextEditController, placeTextController)
      ],
    );
  }

  ///Executed when the user presses on a location TextField
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
      PanelExtensions.of(context: context).getClosetDock(
          feature.geometry?.coordinates.first,
          feature.geometry?.coordinates.last,
          editDockTextEditController);
      // getClosetDock(feature.geometry?.coordinates.first,
      //     feature.geometry?.coordinates.last, editDockTextEditController);
    }
    print("RESULT => $result");
  }

  // getClosetDock(double? lat, double? lng,
  //     TextEditingController editDockTextEditController) async {
  //   LatLong.LatLng latlngPlace =
  //       LatLong.LatLng(lat!, lng!); //coverting list to latlng
  //   dockingStationManager _stationManager = dockingStationManager();
  //   await _stationManager.importStations();
  //   print(latlngPlace);
  //   DockingStation closestDock = _stationManager.getClosestDock(latlngPlace);
  //   print("KEPPENS");
  //   // print(closestDock);
  //   this.closetDockStation = closestDock;
  //   print("closet dock!!!!! ${closestDock.name}");
  //   print("closet dock???????? ${closetDockStation?.name}");
  //   editDockTextEditController.text = closestDock.name;
  //   print("hi");
  // }

  ///Handler for when the user removes a dynamic widget from the list
  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }

  ///Reacts to user input for the location TextField
  void checkInputLocation() {
    PanelExtensions.of()
        .checkInputLocation(placeTextController, editDockTextEditController);
  }

  ///When called, this function sets location of a TextField to the users current location
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
