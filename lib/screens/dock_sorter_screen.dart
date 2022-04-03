import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_station_model.dart';
import 'package:veloplan/providers/docking_station_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/docking_stations_sorting_widget.dart';

/// Screen displaying filtered stations around a chosen dock with functionality to sort stations
/// and view on map.
/// Author(s): Rahin Ashraf, Fariha Choudhury k20059723
/// Contributor(s): Nicole, Marija
class DockSorterScreen extends StatefulWidget {
  late final LatLng userCoord;
  final DockingStation? selectedDockStation;
  DockSorterScreen(this.userCoord, {Key? key, this.selectedDockStation})
      : super(key: key);

  @override
  _DockSorterScreen createState() => _DockSorterScreen();
}

class _DockSorterScreen extends State<DockSorterScreen> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  final panelController = PanelController();
  late List<DockingStation> filteredDockingStations = [];
  late LatLng userCoordinates;
  late TextEditingController editDockTextEditController;
  late BaseMapboxStationMap _baseMapWithStation;
  List<LatLng> _docks = [];
  Alerts alert = Alerts();

  final Set<Symbol> editDocksSymbols = {};
  final Set<Symbol> selectedDockSymbol = {};

  @override
  void initState() {
    userCoordinates = super.widget.userCoord;
    super.initState();
  }

  ///Gets the 10 closest docking stations to the chosen [userCoordinates] and adds list [_docks]
  void getFilteredDocks(LatLng userCoordinates) async {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = await _stationManager.importStations();
    filteredDockingStations =
        _stationManager.get10ClosestDocks(userCoordinates);
    for (var station in filteredDockingStations) {
      _docks.add(LatLng(station.lat, station.lon));
    }
    // Call on map details after retrieving docking station data
    setBaseMapFeatures();
    displayStations();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.4;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.4;
    getFilteredDocks(userCoordinates);
    return Scaffold(
        body: SlidingUpPanel(
      padding: const EdgeInsets.only(left: 10, right: 10),
      minHeight: panelHeightClosed,
      maxHeight: panelHeightOpen,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      controller: panelController,
      body: ScopedModelDescendant<MapModel>(
          builder: (BuildContext context, Widget? child, MapModel model) {
        _baseMapWithStation = BaseMapboxStationMap(
          _docks,
          userCoordinates,
          model,
        );
        addBackButton();
        return Stack(children: _baseMapWithStation.getWidgets());
      }),
      panelBuilder: (controller) => DockSorter(
        userCoordinates,
        controller: controller,
        selectedDockStation: widget.selectedDockStation,
      ),
    ));
  }

  /// Sets the [filteredDockingStations] list and [editDockTextEditController] to base map.
  void setBaseMapFeatures() {
    _baseMapWithStation.setStationList(filteredDockingStations, _docks);
  }

  /// Displays the [filteredDockingStations] list with markers with camera focus around default choice
  /// and add tap on these markers.
  void displayStations() {
    _baseMapWithStation.displayFeaturesAndRefocus(
        filteredDockingStations, filteredDockingStations[0]);
    _baseMapWithStation.refocusCamera(_docks);
    _baseMapWithStation.controller!.onSymbolTapped
        .add(_baseMapWithStation.onSymbolTapped);
  }

  /// Redirects user back to the Journey Planner with [chosenDock].
  void addBackButton() {
    _baseMapWithStation.addWidget(Align(
      alignment: Alignment(-0.95, -0.9),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: CircleBorder(),
          padding: EdgeInsets.all(8),
        ),
        onPressed: () {
          try {
            Navigator.pop(context, _baseMapWithStation.chosenDock);
          } catch (e) {
            alert.showSnackBarErrorMessage(
                context, "Hold on! We're loading some data...");
          }
        },
        child: Icon(Icons.arrow_back_rounded, color: Colors.green),
      ),
    ));
  }
}
