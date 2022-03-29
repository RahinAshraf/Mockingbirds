import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';
import '../helpers/live_location_helper.dart';
import '../providers/location_service.dart';

///The widgets the user dynamically creates during runtime, for them to specify the locations of the journey.
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
  late Map<int, LatLng> latLngMap;

  ///set the position of the selected coordinates list to the passed in index
  void setIndex(index) {
    position = index;
  }

  ///listen to changes for user input on the location specified in the location textfield
  @override
  void initState() {
    placeTextController.addListener(() {
      PanelExtensions.of().checkInputLocation(placeTextController, editDockTextEditController, latLngMap, position);
    });
  }

  DynamicWidget({Key? key, required this.selectedCoords, this.coordDataMap, required this.latLngMap })
      : super(key: key);

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
                    latLngMap.removeWhere((key, value) => key == position);
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
                      final ext = PanelExtensions.of(context:context);
                      ext.checkInputLocation(placeTextController,
                          editDockTextEditController, latLngMap, position);
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
      PanelExtensions(context: context).buildDefaultClosestDock(editDockTextEditController,
          placeTextController, latLngMap, position: position)
      ],
    );
  }

  ///Executed when the user presses on a location TextField. The [position] is the position of the SearchBar of destinations
  ///respect to the other SearchBars in the Journey Planner
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
      PanelExtensions.of(context: context).getClosetDock(feature.geometry?.coordinates.first,
          feature.geometry?.coordinates.last, editDockTextEditController, latLngMap, position);
    }
    print("RESULT => $result");
  }

  ///Handler for when the user removes a dynamic widget from the list
  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }

  ///Reacts to user input for the location TextField
  void checkInputLocation({int? position}){
    PanelExtensions.of().checkInputLocation(placeTextController, editDockTextEditController, latLngMap, position ?? this.position);
  }

  ///When called, this function sets location of a TextField to the users current location. The [controller] is filled in
  ///with the current location of the user.
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

