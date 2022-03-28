import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/alerts.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/dock_sorter_screen.dart';

/// Helper class to build the bubble underneath every location TextField.
class PanelExtensions {
  final locationService = LocationService();
  BuildContext? context;
  Alerts alert = Alerts();

  PanelExtensions({required this.context});

  static PanelExtensions of({BuildContext? context}) {
    return PanelExtensions(context: context);
  }

  /// Builds the field displaying the closest docking station from the place specified in the location TextField.
  Widget buildDefaultClosestDock(
      TextEditingController editDockTextEditController,
      TextEditingController placeTextController) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.subdirectory_arrow_right),
          onPressed: () {},
        ),
        Expanded(
          child: TextField(
            enabled: false,
            controller: editDockTextEditController,
            decoration: InputDecoration(
              hintText: "Default closest dock",
            ),
          ),
        ),
        IconButton(
            onPressed: () async {
              if (placeTextController.text.isEmpty) {
                alert.showSnackBarErrorMessage(
                    context!, alert.fillInLocationBeforeEditingDockMesssage);
                return;
              }
              List temp = await locationService
                  .getPlaceCoords(placeTextController.text);
              checkInputLocation(
                  placeTextController, editDockTextEditController);
              Navigator.push(
                  context!,
                  MaterialPageRoute(
                      builder: (context) =>
                          DockSorterScreen(_latLng(temp.first, temp.last))));
            },
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.navigate_next_outlined,
            )),
      ],
    );
  }

  LatLong.LatLng _latLng(double lat, double lng) => LatLong.LatLng(lat, lng);

  void checkInputLocation(TextEditingController placeTextController,
      TextEditingController editDockTextEditController) async {
    print("THIS IS CLOSET DOCK");
    if (placeTextController.text.isEmpty) {
      print("Nothing specified");
    } else {
      print("REACHED METHOD GETCLOSETDOCK");
      List coordPlace = await locationService.getPlaceCoords(
          placeTextController.text); // getting coord of the place [lat,lng]
      getClosetDock(
          coordPlace.first, coordPlace.last, editDockTextEditController);
      //TODO: change to get closet dock with available bikes after getting num of cyclist
    }
  }

  /// Fills in the bubble displayed under every TextField with the name of the docking station closest
  /// to the location specified by the user.
  void getClosetDock(double? lat, double? lng,
      TextEditingController editDockTextEditController) async {
    LatLong.LatLng latlngPlace =
        LatLong.LatLng(lat!, lng!); // converting list to latlng
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    print(latlngPlace);
    DockingStation closetDock = _stationManager.getClosestDock(latlngPlace);
    print("closet dock ${closetDock.name}");
    editDockTextEditController.text = closetDock.name;
  }
}
