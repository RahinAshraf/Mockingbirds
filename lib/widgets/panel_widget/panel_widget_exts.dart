import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/alerts.dart';
import '../../models/docking_station.dart';
import '../../providers/docking_station_manager.dart';
import '../../providers/location_service.dart';
import '../../screens/dock_sorter_screen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/dock_sorter_screen.dart';

/// Helper class to build the bubble underneath every location TextField.
/// Author: Rahin,
/// Contributor(s): Fariha
class PanelExtensions {
  final locationService = LocationService();
  BuildContext? context;
  Alerts alert = Alerts();
  DockingStation? _dockingStation;
  List<LatLng>? dockingStationList;

  PanelExtensions({required this.context});

  static PanelExtensions of({BuildContext? context}) {
    return PanelExtensions(context: context);
  }

  ///Builds the widget which displays the closest docking station with the [editDockTextEditController]
  /// from the place specified in the location TextField [placeTextController] - if it has been specified.
  Widget buildDefaultClosestDock(
      TextEditingController editDockTextEditController,
      TextEditingController placeTextController,
      Map<int, DockingStation> latLngMap,
      bool isFrom,
      int numberCyclists,
      bool isScheduled,
      {int position = -1}) {
    BehaviorSubject<String> dockText = BehaviorSubject();
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.subdirectory_arrow_right),
          onPressed: () {},
        ),
        Expanded(
          child: StreamBuilder<String>(
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                //  editDockTextEditController.text = snapshot.requireData;
              }
              return TextField(
                key: Key(isFrom.toString()),
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
              );
            },
            stream: dockText,
          ),
        ),
        Expanded(
          child: !isScheduled
              ? IconButton(
                  onPressed: () async {
                    if (placeTextController.text.isEmpty) {
                      alert.showSnackBarErrorMessage(context!,
                          alert.fillInLocationBeforeEditingDockMesssage);
                      return;
                    }
                    List temp = await locationService
                        .getPlaceCoords(placeTextController.text);

                    final result = await Navigator.push<DockingStation>(
                        context!,
                        MaterialPageRoute(
                            builder: (context) => DockSorterScreen(
                                  convertDestinationLocationFromDoublesToLatLng(
                                      temp.first, temp.last),
                                  selectedDockStation: DockingStation(
                                      "ds1ID",
                                      "ds1",
                                      true,
                                      true,
                                      10,
                                      11,
                                      12,
                                      15.6,
                                      89.0),
                                )));

                    checkInputLocation(
                        placeTextController,
                        editDockTextEditController,
                        latLngMap,
                        position,
                        isFrom,
                        numberCyclists,
                        address: result?.name,
                        closesDockLatLng: result);
                  },
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.navigate_next_outlined,
                  ))
              : Text(""),
          flex: 0,
        ),
      ],
    );
  }

  ///Converts the coordinates of the location given as [lat] and [lng] and returns the same coordinate as a [LatLong] object
  LatLong.LatLng convertDestinationLocationFromDoublesToLatLng(
          double lat, double lng) =>
      LatLong.LatLng(lat, lng);

  ///Handles the different situations for when user inputs a destination.
  ///The [placeTextController] is where the London destination the user wishes to visit is specified.
  ///The [editDockTextEditController] is where the TextField that specifies the closest docking station to the specified
  ///London destination - if it has been specified.
  void checkInputLocation(
      TextEditingController placeTextController,
      TextEditingController editDockTextEditController,
      Map<int, DockingStation> latLngMap,
      int position,
      bool isFrom,
      int numberCyclists,
      {String? address,
      DockingStation? closesDockLatLng}) async {
    if (placeTextController.text.isEmpty) {
      //do nothing
    } else {
      List coordPlace = await locationService.getPlaceCoords(placeTextController
          .text); //getting coordinates of the place specified as the destination to visit

      fillClosestDockBubble(
          coordPlace.first,
          coordPlace.last,
          editDockTextEditController,
          latLngMap,
          position,
          isFrom,
          numberCyclists,
          address: address,
          closesDockLatLng: closesDockLatLng);
    }
  }

  ///Fills in the [editDockTextEditController] which is displayed underneath every TextField for destinations,
  /// with the name of the docking station which is closest to the location specified by the user.
  /// The London destination the user specifies to visit, is given together by the [lat] and [lng] of the destination.
  void fillClosestDockBubble(
      double? lat,
      double? lng,
      TextEditingController editDockTextEditController,
      Map<int, DockingStation> latLngMap,
      int position,
      bool isFrom,
      int numberOfCyclists,
      {String? address,
      DockingStation? closesDockLatLng}) async {
    LatLong.LatLng latlngPlace = LatLong.LatLng(lat!, lng!);
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();

    late DockingStation closestDock;

    if (null == closesDockLatLng) {
      if (isFrom) {
        closestDock = _stationManager.getClosestDockWithAvailableBikes(
            latlngPlace, numberOfCyclists);
      } else {
        closestDock = _stationManager.getClosestDockWithAvailableSpace(
            latlngPlace, numberOfCyclists);
      }
      editDockTextEditController.text = closestDock.name;
      latLngMap[position] = closestDock;
      this._dockingStation = closestDock;
    } else {
      editDockTextEditController.text = address!;
      latLngMap[position] = closesDockLatLng;
    }
  }
}
