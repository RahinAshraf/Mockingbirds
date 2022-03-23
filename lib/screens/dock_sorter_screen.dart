import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_station_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import '../providers/docking_station_manager.dart';
import '../widgets/docking_stations_sorting_widget.dart';

import 'package:scoped_model/scoped_model.dart';

/// Screen displaying filtered stations around a chosen dock with functionality to sort stations
/// and view on map
/// Author(s): Nicole, Fariha

class DockSorterScreen extends StatefulWidget {
  late final LatLng userCoord;
  late TextEditingController editDockTextEditController;
  //late DockingStation closetDockStation;

  DockSorterScreen(this.userCoord, this.editDockTextEditController,
      //this.closetDockStation,
      {Key? key})
      : super(key: key);

  @override
  _DockSorterScreen createState() => _DockSorterScreen();
}

class _DockSorterScreen extends State<DockSorterScreen> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  final panelController = PanelController();
  late List<DockingStation> filteredDockingStations = [];
  late LatLng userCoordinates; //IS THIS THE SAME AS _FOCUSDOCK???
  late TextEditingController editDockTextEditController;

  // late BaseMapboxMap _baseMap;
  late BaseMapboxStationMap _baseMapWithStation;
  List<LatLng> _docks = [];
  late LatLng _focusDock; //The chosen dock - userCoord

  late DockingStation focusStation;

  final Set<Symbol> editDocksSymbols = {};
  final Set<Symbol> selectedDockSymbol = {};

  String text = ""; //closetDockStation;

  @override
  void initState() {
    userCoordinates = super.widget.userCoord;
    editDockTextEditController = super.widget.editDockTextEditController;
    super.initState();
  }

  ///Gets the 10 closest docking stations to the chosen [userCoordinates] and adds list [_docks]
  void getFilteredDocks(LatLng userCoordinates) async {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = await _stationManager.importStations();
    filteredDockingStations =
        _stationManager.get10ClosestDocks(userCoordinates);
    focusStation = filteredDockingStations[0];
    //Add to a list of DockingStations^
    for (var station in filteredDockingStations) {
      _docks.add(LatLng(station.lat, station.lon));
      //Add to a list of LatLng^
    }
    //As future is returned for filtered docks, must call on map details after retrieving data
    refreshStations();
  }

  @override
  Widget build(BuildContext context) {
    //focusStation = super.widget.closetDockStation;
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.4;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.4;
    getFilteredDocks(userCoordinates);

    return Scaffold(
        body: SlidingUpPanel(
      padding: const EdgeInsets.only(left: 10, right: 10),
      minHeight: panelHeightClosed,
      maxHeight: panelHeightOpen,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      parallaxEnabled: true,
      parallaxOffset: .5,
      controller: panelController,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: ScopedModelDescendant<MapModel>(builder:
                    (BuildContext context, Widget? child, MapModel model) {
                  _baseMapWithStation = BaseMapboxStationMap(
                    _docks,
                    userCoordinates,
                    // focusStation,
                    model,
                  );
                  return SafeArea(
                      child: Stack(children: _baseMapWithStation.getWidgets()));
                })),
          ],
        ),
      ),
      panelBuilder: (controller) =>
          DockSorter(userCoordinates, controller: controller),
    ));
  }

  /// Resets docking station markers to display markers and add tap functionality
  void refreshStations() {
    _baseMapWithStation.setStationList(filteredDockingStations, _docks);

    _baseMapWithStation.setEditTextController(editDockTextEditController);

    _baseMapWithStation.displayFeaturesAndRefocus(
        filteredDockingStations, filteredDockingStations[0]);
    // focusStation = filteredDockingStations[0] ^
    _baseMapWithStation.refocusCamera(_docks);

    _baseMapWithStation.controller!.onSymbolTapped
        .add(_baseMapWithStation.onSymbolTapped);
  }
}
