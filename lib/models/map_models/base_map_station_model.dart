import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
// import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
// import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
// import 'package:veloplan/utilities/travel_type.dart';

/// Class to display a mapbox map with markers for a station and its surroudning stations, and other possible widgets
/// Author(s): Fariha Choudhury k20059723

/// OVERRIDE ROUTE MAP - PASS IN JOURNEY - BUT DO NOT DISPLAY, CALL FUNCTIONS FROM SCREEN SEPARATELY.

class BaseMapboxStationMap extends BaseMapboxRouteMap {
  late final List<LatLng> _journey;
  LatLng
      _curentDock; //change to type docking station and retrieve station via lat lng
  //DockingStation _chosenDock;
  final Set<Symbol> filteredDockSymbols = {};
  final Set<Symbol> currentRedSymbol = {};

  BaseMapboxStationMap(
    this._journey,
    this._curentDock,
    //this._chosenDock,
    MapModel model,
  ) : super(_journey, model, false);

  late DockingStation chosenDock; //= _chosenDock;
  late List<DockingStation> dockingStations;
  late TextEditingController _editDockTextEditController;

  // bool tapped = false;

  String text = "  ";

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);

    //model.fetchDockingStations();
    //chosenDock =
    //_displayFeatures(_journey);
    // onMarkerTapped(controller);
    //chosenDock = _chosenDock;
    // text = "" + chosenDock.name.toString();
    // displayFeaturesAndRefocus(_journey, dockingStations, );
    print("journey: " + _journey.toString());
    print("journey: " + _journey.length.toString());
    print("currentDock: " + _curentDock.toString());
  }

  /// Calls [onSymbolTapped] functionality for docking station markers on maps that do not [_displayPolyline]
  @override
  void onMarkerTapped(MapboxMapController controller) {
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Retrieves the [stationData] of the docking station [symbol] that was tapped
  @override
  // Future<void> onSymbolTapped(Symbol symbol) async {
  //   selectedSymbol = symbol;
  //   Future<LatLng> variable = controller!.getSymbolLatLng(symbol);
  //   if (selectedSymbol != null) {
  //     LatLng selectedtLatLng = await variable;
  //     //displayDockCard(current);
  //     print("SELECTED SYMBOL IS..............: " +
  //         symbol.toString() +
  //         "   " +
  //         selectedtLatLng.toString());
  //   }
  // }
  Future<void> onSymbolTapped(Symbol symbol) async {
    selectedSymbol = symbol;
    if (selectedSymbol != null) {
      Map<dynamic, dynamic>? stationData = symbol.data;
      DockingStation station = stationData!["station"];

      _curentDock = LatLng(station.lat, station.lon);
      print("SELECTED SYMBOL IS..............: ");
      print(station.toString());

      if (station != chosenDock) {
        super.resetCameraPosition(
            _curentDock, cameraPosition.zoom); //refocus on selected dock.
        // remove old red

        //removeMarkers(controller!, {symbol});
        // replace old red with yellow
        // remopve old yellow
        // place new red

        // REMOVE ALL MARKERS:
        removeMarkers(controller!, filteredDockSymbols);
        // filteredDockSymbols.clear(); //clear set ??
        //assign index 1 as red:
        dockingStations.remove(station);
        dockingStations.insert(0, station);

        print("chosen now:" + dockingStations[0].name);

        displayFeaturesAndRefocus(
            dockingStations, dockingStations[0]); //1st = red, rest = yellow

        //alternative: station
        // displayFeaturesAndRefocus(
        //     dockingStations, station);

        editChosenDockText(station);

        chosenDock = station;
        print("should be same as ^^ :" + chosenDock.name.toString());
      }
      // chosenDock = station;

      // text = "" + chosenDock.name.toString();

      print(filteredDockSymbols.length);

      //CHECK IF THIS WORKS AFTER ??/
      // editChosenDockText(station);
    }

    /// CHANGE TO DO:
    /// bring selected dock to front of list;  mylist.insert(0, mylist.pop(mylist.index(targetvalue)))
    ///
  }

  void setStationList(
      List<DockingStation> stations, List<LatLng> latLngPoints) {
    dockingStations = stations;
    print(dockingStations);
    chosenDock = stations[0];
    // this._journey = latLngPoints;
  }

  /// Display red and yellow markers
  void displayFeaturesAndRefocus(
      List<DockingStation> stations, DockingStation focus) {
    // refocusCamera(latLngPoints);
    stations.remove(focus); //remove index 0 - will be red
    print("After removing symbol clicked on :   " + stations.length.toString());
    setRedMarkers(
        controller!, [focus], filteredDockSymbols); //add red and remove
    setYellowMarkers(
        controller!, stations, filteredDockSymbols); //add rest as yellow

    stations.insert(0, focus); //put red back into first index
    print("put in red back :   " + stations.length.toString());
  }

  /// Refocus camera positioning to focus on the [journey] polyline
  void refocusCamera(List<LatLng> latLngPoints) {
    //List<LatLng> journey
    LatLng center = getCenter(latLngPoints);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(latLngPoints);
    double zoom = getZoom(calculateDistance(center, corners.item1));
    print(latLngPoints);

    cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void setEditTextController(TextEditingController editDockTextEditController) {
    this._editDockTextEditController = editDockTextEditController;
  }

  void editChosenDockText(DockingStation chosenDock) {
    this._editDockTextEditController.text = chosenDock.name;
  }

  // void _refocusCamera(List<LatLng> journey) {
  //   LatLng center = getCenter(journey);
  //   Tuple2<LatLng, LatLng> corners = getCornerCoordinates(journey);
  //   double zoom = getZoom(calculateDistance(center, corners.item1));

  //   cameraPosition = CameraPosition(
  //       target: center, //target, //center,
  //       zoom: zoom,
  //       tilt: 5);
  //   controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // }

  /// Sets the [journey] geometry
  // void _setJourney(List<LatLng> journey) async {
  //   List<dynamic> journeyPoints = [];
  //   if (journey.length > 1) {
  //     _routeResponse = await _manager.getDirections(
  //         journey[0], journey[1], NavigationType.walking);
  //     for (int i = 0; i < journey.length - 1; ++i) {
  //       var directions = await _manager.getDirections(
  //           journey[i], journey[i + 1], NavigationType.cycling);
  //       for (dynamic a in directions['geometry']!['coordinates']) {
  //         journeyPoints.add(a);
  //       }
  //       _routeResponse['geometry']
  //           .update("coordinates", (value) => journeyPoints);
  //     }
  //     _displayJourney();
  //   }
  // }

  /// Draws out the journey onto map
  // void _displayJourney() async {
  //   _fills = await setFills(_fills, _routeResponse['geometry']);
  //   addFills(controller!, _fills, model);
  //   _setDistanceAndTime();
  // }

  /// Sets distance and time
  // void _setDistanceAndTime() async {
  //   try {
  //     var duration = await _manager.getDistance() as double; //meters
  //     var distance = await _manager.getDuration() as double; //sec
  //     _totalDistanceAndTime = "distance: " +
  //         (distance / 1000).truncate().toString() +
  //         ", duration: " +
  //         (duration / 60).truncate().toString();
  //   } catch (e) {
  //     _totalDistanceAndTime = "Route not avalible";
  //   }
  // }

  /// Gets the [_totalDistanceAndTime] of a journey
  // String _getTotalDistance() {
  //   return _totalDistanceAndTime;
  // }
}
