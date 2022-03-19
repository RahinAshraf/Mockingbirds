import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/models/map_models/base_map_station_model.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import '../providers/docking_station_manager.dart';
import '../widgets/docking_stations_sorting_widget.dart';

import '../../models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Screen displaying filtered stations around a chosen dock with functionality to sort stations
/// and view on map
/// Author(s): Nicole, Fariha

class DockSorterScreen extends StatefulWidget {
  late final LatLng userCoord;

  DockSorterScreen(this.userCoord, {Key? key}) : super(key: key);

  @override
  _DockSorterScreen createState() => _DockSorterScreen();
}

class _DockSorterScreen extends State<DockSorterScreen> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  final panelController = PanelController();
  late List<DockingStation> filteredDockingStations = [];
  late LatLng userCoordinates; //IS THIS THE SAME AS _FOCUSDOCK???

  // late BaseMapboxMap _baseMap;
  late BaseMapboxStationMap _baseMapWithStation;
  List<LatLng> _docks = [];
  late LatLng _focusDock; //The chosen dock - userCoord

  final Set<Symbol> editDocksSymbols = {};
  final Set<Symbol> selectedDockSymbol = {};

  @override
  void initState() {
    userCoordinates = super.widget.userCoord;
    //getFilteredDocks(userCoordinates);

    super.initState();
  }

  ///Gets the 10 closest docking stations to the chosen [userCoordinates] and adds list [_docks]
  void getFilteredDocks(LatLng userCoordinates) async {
    final dockingStationManager _stationManager = dockingStationManager();
    var list = await _stationManager.importStations();
    filteredDockingStations =
        _stationManager.get10ClosestDocks(userCoordinates);

    for (var station in filteredDockingStations) {
      // print(_docks.length.toString() +
      //     "HIIIIIIIIIIIIIIII FARIHAAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      _docks.add(LatLng(station.lat, station.lon));
    }

    //As future is returned for filtered docks, must call on map details after retrieving data
    refreshStations();
    //print(_docks.toString());
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
                    model,
                  );
                  addClearDocksButton();
                  //SET CAMERA POSITION TO FOCUS ON CHOSEN DOCK: - doesnt work??
                  // _baseMapWithRoute.controller?.animateCamera(
                  //     CameraUpdate.newCameraPosition(
                  //         CameraPosition(target: _docks[0], zoom: 12, tilt: 5)));
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

  /// Resets docking stations - calls map methods of BaseMapboxStationMap as markers cannot be displayed until
  /// fetched (futures).
  void refreshStations() {
    // removePolylineMarkers(_baseMapWithStation.controller!, editDocksSymbols);
    // setPolylineMarkers(
    //     _baseMapWithStation.controller!, _docks, editDocksSymbols);
    // _baseMapWithStation.refocusCamera(_docks);
    _baseMapWithStation.displayFeatures(_docks, userCoordinates);
    _baseMapWithStation.controller!.onSymbolTapped
        .add(_baseMapWithStation.onSymbolTapped);
  }

  /// For testing
  void addClearDocksButton() {
    _baseMapWithStation.addWidget(Container(
      alignment: Alignment(-0.5, -0.7),
      child: FloatingActionButton(
        heroTag: "clear docks",
        onPressed: () {
          removePolylineMarkers(
              _baseMapWithStation.controller!,
              _baseMapWithStation
                  .filteredDockSymbols); //removes surrounding docks.
        },
        child: const Icon(Icons.clear),
      ),
    ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
// import 'package:veloplan/helpers/shared_prefs.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:veloplan/models/docking_station.dart';
// import 'package:veloplan/models/map_models/base_map_model.dart';
// import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
// import 'package:veloplan/scoped_models/map_model.dart';
// import '../providers/docking_station_manager.dart';
// import '../widgets/docking_stations_sorting_widget.dart';

// import '../../models/map_models/base_map_with_route_model.dart';
// import 'package:scoped_model/scoped_model.dart';

// /// Screen displaying filtered stations around a chosen dock with functionality to sort stations
// /// and view on map
// /// Author(s): Nicole, Fariha

// class DockSorterScreen extends StatefulWidget {
//   late final LatLng userCoord;

//   DockSorterScreen(this.userCoord, {Key? key}) : super(key: key);

//   @override
//   _DockSorterScreen createState() => _DockSorterScreen();
// }

// class _DockSorterScreen extends State<DockSorterScreen> {
//   LatLng currentLatLng = getLatLngFromSharedPrefs();
//   final panelController = PanelController();
//   late List<DockingStation> filteredDockingStations = [];
//   late LatLng userCoordinates;

//   late BaseMapboxMap _baseMap;
//   late BaseMapboxRouteMap _baseMapWithRoute;
//   List<LatLng> _docks = [];
//   late LatLng _focusDock; //The chosen dock - userCoord

//   final Set<Symbol> editDocksSymbols = {};
//   final Set<Symbol> selectedDockSymbol = {};

//   @override
//   void initState() {
//     userCoordinates = super.widget.userCoord;
//     getFilteredDocks(userCoordinates);

//     super.initState();
//   }

//   ///Gets the 10 closest docking stations to the chosen [userCoordinates] and adds list [_docks]
//   void getFilteredDocks(LatLng userCoordinates) async {
//     final dockingStationManager _stationManager = dockingStationManager();
//     var list = await _stationManager.importStations();
//     filteredDockingStations =
//         _stationManager.get10ClosestDocks(userCoordinates);

//     for (var station in filteredDockingStations) {
//       // print(_docks.length.toString() +
//       //     "HIIIIIIIIIIIIIIII FARIHAAAAAAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//       _docks.add(LatLng(station.lat, station.lon));
//     }
//     refreshStations();
//     //print(_docks.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final panelHeightClosed = MediaQuery.of(context).size.height * 0.4;
//     final panelHeightOpen = MediaQuery.of(context).size.height * 0.4;

//     return Scaffold(
//         body: SlidingUpPanel(
//       padding: const EdgeInsets.only(left: 10, right: 10),
//       minHeight: panelHeightClosed,
//       maxHeight: panelHeightOpen,
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       parallaxEnabled: true,
//       parallaxOffset: .5,
//       controller: panelController,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SizedBox(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: ScopedModelDescendant<MapModel>(builder:
//                     (BuildContext context, Widget? child, MapModel model) {
//                   _baseMapWithRoute = BaseMapboxRouteMap(_docks, model, false);
//                   addClearDocksButton();
//                   //SET CAMERA POSITION TO FOCUS ON CHOSEN DOCK: - doesnt work??
//                   // _baseMapWithRoute.controller?.animateCamera(
//                   //     CameraUpdate.newCameraPosition(
//                   //         CameraPosition(target: _docks[0], zoom: 12, tilt: 5)));
//                   return SafeArea(
//                       child: Stack(children: _baseMapWithRoute.getWidgets()));
//                 })),
//           ],
//         ),
//       ),
//       panelBuilder: (controller) =>
//           DockSorter(userCoordinates, controller: controller),
//     ));
//   }

//   /// Resets docking stations
//   void refreshStations() {
//     // removePolylineMarkers(
//     //     _baseMapWithRoute.controller!, _baseMapWithRoute.polylineSymbols);
//     //RESET THE DOCKS -- THEN SET MARKERS AGAIN
//     // setPolylineMarkers(_baseMapWithRoute.controller!, _docks,
//     //     _baseMapWithRoute.polylineSymbols);

//     //Use set from this class - to differenciate which dock was selected.
//     removePolylineMarkers(_baseMapWithRoute.controller!, editDocksSymbols);
//     setPolylineMarkers(_baseMapWithRoute.controller!, _docks, editDocksSymbols);

//     _baseMapWithRoute.controller!.onSymbolTapped
//         .add(_baseMapWithRoute.onSymbolTapped);
//   }

//   /// For testing
//   void addClearDocksButton() {
//     _baseMapWithRoute.addWidget(Container(
//       alignment: Alignment(-0.5, -0.7),
//       child: FloatingActionButton(
//         heroTag: "clear docks",
//         onPressed: () {
//           removePolylineMarkers(
//               _baseMapWithRoute.controller!, _baseMapWithRoute.polylineSymbols);
//         },
//         child: const Icon(Icons.clear),
//       ),
//     ));
//   }
// }

//// TO DO:
/// - Get chosen symbol and return it as
/// - remove on tap from these markers
