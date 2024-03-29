import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';

/// Class to display a mapbox map with markers for a station and its surroudning stations, and other possible widgets
/// Author(s): Fariha Choudhury k20059723

class BaseMapboxStationMap extends BaseMapboxMap {
  late final List<LatLng> _journey;
  LatLng _curentDock;
  final Set<Symbol> filteredDockSymbols = {};
  final Set<Symbol> currentRedSymbol = {};

  BaseMapboxStationMap(
    this._journey,
    this._curentDock,
    MapModel model,
  ) : super(model);

  late DockingStation chosenDock;
  late List<DockingStation> dockingStations;

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
  }

  /// Calls [onSymbolTapped] functionality for docking station markers on maps that do not [_displayPolyline]
  void onMarkerTapped(MapboxMapController controller) {
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Retrieves the [stationData] of the docking station [symbol] that was tapped
  @override
  Future<void> onSymbolTapped(Symbol symbol) async {
    selectedSymbol = symbol;
    if (selectedSymbol != null) {
      Map<dynamic, dynamic>? stationData = symbol.data;
      DockingStation station = stationData!["station"];
      _curentDock = LatLng(station.lat, station.lon);
      if (station != chosenDock) {
        super.resetCameraPosition(
            _curentDock, cameraPosition.zoom); //refocus on selected dock.
        removeMarkers(controller!, filteredDockSymbols);
        dockingStations.remove(station);
        dockingStations.insert(0, station);
        displayFeaturesAndRefocus(
            dockingStations, dockingStations[0]); //1st=red, rest=yellow

        chosenDock = station;
      }
    }
  }

  void setStationList(
      List<DockingStation> stations, List<LatLng> latLngPoints) {
    dockingStations = stations;
    chosenDock = stations[0];
  }

  /// Display red and yellow markers
  void displayFeaturesAndRefocus(
      List<DockingStation> stations, DockingStation focus) {
    stations.remove(focus); //remove index 0 - will be red
    setRedMarkers(controller!, [focus], filteredDockSymbols); //add red
    setYellowMarkers(controller!, stations, filteredDockSymbols); //adds yellows
    stations.insert(0, focus); //put red back into first index
  }

  /// Refocus camera positioning to focus on the [journey] polyline
  void refocusCamera(List<LatLng> latLngPoints) {
    LatLng center = getCenter(latLngPoints);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(latLngPoints);
    double zoom = getZoom(calculateDistance(center, corners.item1));
    cameraPosition = CameraPosition(target: center, zoom: zoom, tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
