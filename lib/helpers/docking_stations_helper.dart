// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:veloplan/models/docking_station.dart';

// import '../providers/docking_station_manager.dart';

// class DocksHelper {
//   late Map<LatLng, String> dockLatLngName;
//   late List<DockingStation> docks;

//   DocksHelper() {
//     fetchDockingStations();
//     setDockMap();
//   }

//   /// Fetch all docking stations
//   fetchDockingStations() async {
//     final dockingStationManager _stationManager = dockingStationManager();
//     await _stationManager.importStations();
//     docks = _stationManager.stations;
//   }

//   void setDockMap() {
//     for (var dock in docks) {
//       dockLatLngName.addAll({dock.getLatlng(): dock.name});
//     }
//   }

//   String getDockName(LatLng coord){
//     return dockLatLngName.containsKey(key)



//   }
  

// }
