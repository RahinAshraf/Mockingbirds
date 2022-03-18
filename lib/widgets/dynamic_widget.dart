import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget_exts.dart';
import '../helpers/live_location_helper.dart';
import '../providers/location_service.dart';


 ///The widgets the user dynamically creates during runtime, for them to specify the locations of the journey.
 ///Each dynamic widget is a row which comes with a row of children:
 /// - red cross, to delete a location from the journey planner list
 /// - TextField , to insert a location to the journey planner list
 /// - green > icon, to allow users to specify specific docks (if they wish) of the locations user specifies in the TextField


class DynamicWidget extends StatelessWidget {
  final TextEditingController placeTextController = TextEditingController();
  final TextEditingController editDockTextEditController =
  TextEditingController();
  List<List<double?>?>? selectedCoords;
  Function(int)? onDelete;
  int position = -1;
  final locationService = LocationService();
  final Map? coordDataMap;

  void setIndex(index) {
    position = index;
  }

  @override
  void initState() {
    placeTextController.addListener(() {
      PanelExtensions.of().checkInputLocation(placeTextController, editDockTextEditController);
    });
  }

  DynamicWidget({Key? key, required this.selectedCoords, this.coordDataMap})
      : super(key: key);

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
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextField(
                    onEditingComplete: () {
                      print("ONCHANGED");
                      PanelExtensions.of(context:context).checkInputLocation(placeTextController, editDockTextEditController);
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
      PanelExtensions(context: context).buildDefaultClosestDock(editDockTextEditController, placeTextController)
      ],
    );
  }


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
      PanelExtensions.of(context: context).getClosetDock(feature.geometry?.coordinates.first,
          feature.geometry?.coordinates.last, editDockTextEditController);
    }
    print("RESULT => $result");
  }



  void removeDynamic(Function(int) onDelete) {
    this.onDelete = onDelete;
  }

  void checkInputLocation(){

    PanelExtensions.of().checkInputLocation(placeTextController, editDockTextEditController);
  }

  ///When called, this function sets the first location of the journey to the users current location
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

