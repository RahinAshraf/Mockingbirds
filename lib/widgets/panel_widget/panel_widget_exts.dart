import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latLng2;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/alerts.dart';
import 'package:veloplan/widgets/docking_stations_sorting_widget.dart';
import '../../models/docking_station.dart';
import '../../providers/docking_station_manager.dart';
import '../../providers/location_service.dart';
import '../../screens/dock_sorter_screen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rxdart/rxdart.dart';

///Class to create and display the closest docking station for every defined location of the journey.
///  int position = 0;

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

  void setPosition(int index) {
    // position = position;
  }

  ///Builds the widget which displays the closest docking station with the [editDockTextEditController]
  /// from the place specified in the location TextField [placeTextController] - if it has been specified.
  Widget buildDefaultClosestDock(
      TextEditingController editDockTextEditController,
      TextEditingController placeTextController,
      Map<int, LatLng> latLngMap,
      {int position = -1}) {
    BehaviorSubject<String> dockText = BehaviorSubject();
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Icon(Icons.subdirectory_arrow_right),
          flex: 0,
        ),
        Expanded(
          child: StreamBuilder<String>(
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                editDockTextEditController.text = snapshot.requireData;
              }
              return TextField(
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
          child: IconButton(
              onPressed: () async {
                if (placeTextController.text.isEmpty) {
                  alert.showSnackBarErrorMessage(
                      context!, alert.fillInLocationBeforeEditingDockMesssage);
                  print("hello");
                  return;
                }

                List temp = await locationService
                    .getPlaceCoords(placeTextController.text);

                checkInputLocation(placeTextController,
                    editDockTextEditController, latLngMap, position);

                if (_dockingStation != null) {
                  final LatLng? dockStationLatLng = latLngMap[position];
                  final result = await Navigator.push<DockingStation>(
                      context!,
                      MaterialPageRoute(
                          builder: (context) => DockSorterScreen(
                                convertDestinationLocationFromDoublesToLatLng(
                                    temp.first, temp.last),
                                dockingStation: _dockingStation,
                                selectedDockStation: DockingStation("ds1ID", "ds1", true, true, 10, 11, 12, 15.6, 89.0),
                              )));
                  if (result != null) {
                    print("hey position => $position");
                    latLngMap[position] = LatLng( result.lat, result.lon);
                    dockText.sink.add(result.name);
                  }
                } else {
                  // Display docking error message here
                  print("DockingStation is null");
                }
              },
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.navigate_next_outlined,
              )),
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
      Map<int, LatLng> latLngMap,
      int position) async {
    if (placeTextController.text.isEmpty) {
      //do nothing
    } else {
      List coordPlace = await locationService.getPlaceCoords(placeTextController
          .text); //getting coordinates of the place specified as the destination to visit
      getClosetDock(coordPlace.first, coordPlace.last,
          editDockTextEditController, latLngMap, position);
    }
  }

  ///Fills in the [editDockTextEditController] which is displayed underneath every TextField for destinations,
  /// with the name of the docking station which is closest to the location specified by the user.
  /// The London destination the user specifies to visit, is given together by the [lat] and [lng] of the destination.
  void getClosetDock(
      double? lat,
      double? lng,
      TextEditingController editDockTextEditController,
      Map<int, LatLng> latLngMap,
      int position) async {
    LatLong.LatLng latlngPlace = LatLong.LatLng(lat!, lng!);
    dockingStationManager _stationManager = dockingStationManager();
    await _stationManager.importStations();
    DockingStation closetDock = _stationManager.getClosestDock(latlngPlace);
    print("closet dock ${closetDock.name}");
    editDockTextEditController.text = closetDock.name;
    latLngMap[position] = LatLng(closetDock.lat, closetDock.lon);
    print("PRIIIINTING => $position");
    this._dockingStation = closetDock;
  }
}
