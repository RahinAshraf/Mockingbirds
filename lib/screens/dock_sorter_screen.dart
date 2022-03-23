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
    //focusStation = super.widget.closetDockStation;
    //print("focus stattion name ${focusStation.name}");
    //getFilteredDocks(userCoordinates);
    // String text = "" + focusStation.name.toString();

    // Timer mytimer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   implementTime();
    //   // setState(() {});
    // });

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
                  // implementTime();
                  addClearDocksButton();
                  //addDockBar();
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

  // void addDockBar() {
  //   _baseMapWithStation.addWidget(
  //     Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Align(
  //         alignment: Alignment(0, 0.9),
  //         child: Container(
  //             width: 200,
  //             height: 50,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(15.0)),
  //             child: Align(
  //               alignment: Alignment.center,
  //               child: Text("THIS DOESNT WORK " + getStuff(),
  //                   // Timer.periodic(Duration(seconds: 3), (timer) {
  //                   //   implementTime();
  //                   // }),
  //                   //Text("Selected station: " + _baseMapWithStation.text,
  //                   //     setState(() {
  //                   //       focusStation.name.toString();
  //                   //     }), //(_) => setState(() {}),//(_)=> focusStation.name.toString(),
  //                   style: TextStyle(fontSize: 12.0)),
  //             )),
  //       ),
  //     ),
  //   );
  // }

  // String getStuff() {
  //   text = "Selected:   ";
  //   Timer.periodic(Duration(seconds: 5), (timer) {
  //     //text = _baseMapWithStation.chosenDock.name.toString();
  //     text = "hi";
  //   });
  //   return text;
  // }

  // String implementTime() {
  //   print(text);
  //   return text = _baseMapWithStation.chosenDock.name.toString();
  // }

  // Timer mytimer = Timer.periodic(Duration(seconds: 3), (timer) {
  //   implementTime();
  //   // setState(() {});
  // });

  // String setText() {

  //     if (_baseMapWithStation.text = ""  + _chosenDock.name.toString();) {
  //       focusStation = _baseMapWithStation.chosenDock;
  //       //text = focusStation.name.toString();
  //     }
  //     // else{
  //     //   // text = focusStation.name.toString();
  //     // }
  //     // }
  //   return text;
  // }

  // setState(() {
  //   if (focusStation != null) {
  //     text = _baseMapWithStation.chosenDock.toString();
  //   }
  // });

}

/// TO DO:    Add focus dock with a marker too (? does it do it - check -)
/// TO DO:    Add tap; return docking station info
/// TO DO:    After tap; switch colour and redraw map after focussing on that dock (? maybe or leave second part)
/// TO DO:    Refactor drawing helpers; separate latlng and docking station passing; pass in data for stations

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
