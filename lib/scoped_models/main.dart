import 'package:scoped_model/scoped_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/.env.dart';

import '../models/docking_station.dart';
import '../providers/docking_station_manager.dart';

class NavigationModel extends Model {
  String accessToken = MAPBOX_ACCESS_TOKEN;

  // 'pk.eyJ1IjoibW9ja2luZ2JpcmRzIiwiYSI6ImNrempyNnZtajNkbmkybm8xb3lybWE3MTIifQ.AsZJbQPNRb2N3unNdA98nQ';

  late MapboxMapController? controller;
  late CameraPosition _cameraPosition;
  late MapboxMap map;
  LatLng currentLatLng = const LatLng(51.51185004458236, -0.11580820118980878);
  bool showMarkers = false; //for displaying markers with button

  NavigationModel() {
    _cameraPosition = CameraPosition(target: currentLatLng, zoom: 12);
    createMap();
  }

  void _onMapCreated(MapboxMapController controller) async {
    setController(controller);
    fetchDockingStations();
    // controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager
        .importStations()
        .then((value) => placeDockMarkers(_stationManager.stations));
  }

  void createMap() {
    map = MapboxMap(
      accessToken: accessToken,
      initialCameraPosition: _cameraPosition,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      annotationOrder: [AnnotationType.symbol],
    );
  }

  void placeDockMarkers(List<DockingStation> docks) {
    for (var station in docks) {
      controller!.addSymbol(
        SymbolOptions(
            geometry: LatLng(station.lat, station.lon),
            iconSize: 0.7,
            iconImage: "assets/icon/bicycle.png"),
      );
    }
  }

  MapboxMapController? getController() {
    return controller;
  }

  void setController(MapboxMapController controller) {
    this.controller = controller;
  }

  MapboxMap getMap() {
    return map;
  }

  void setMap(MapboxMap map) {
    this.map = map;
  }

  String _name = "";
  int _count = 0;

  String get name {
    return _name;
  }

  int get count {
    return _count;
  }

  void updateName(String name) {
    _name = name;
  }

  void incrementCount() {
    _count += 1;
    notifyListeners();
  }
}
