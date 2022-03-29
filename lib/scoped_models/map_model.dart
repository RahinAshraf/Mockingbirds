import 'package:scoped_model/scoped_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/navigation_helpers/map_drawings.dart';
import '../providers/docking_station_manager.dart';

/// Class to store scoped models related to navigation
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737,

class MapModel extends Model {
  late MapboxMapController? controller;
  final Set<Symbol> dockSymbols = {};

  /// Fetch all docking stations
  void fetchDockingStations() {
    final dockingStationManager _stationManager = dockingStationManager();
    _stationManager.importStations().then((value) =>
        placeDockMarkers(controller!, _stationManager.stations, dockSymbols));
  }

  /// Gets the Mapbox [controller]
  MapboxMapController? getController() {
    return controller;
  }

  /// Sets the Mapbox [controller]
  void setController(MapboxMapController controller) {
    this.controller = controller;
  }
}
