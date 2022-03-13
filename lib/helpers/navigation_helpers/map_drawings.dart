import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../models/docking_station.dart';

/// Helper methods related to adding layers to the map
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

/// Adds symbol layer to map for every docking station in London
void placeDockMarkers(
    MapboxMapController controller, List<DockingStation> docks) {
  for (var station in docks) {
    controller.addSymbol(
      SymbolOptions(
          geometry: LatLng(station.lat, station.lon),
          iconSize: 0.7,
          iconImage: "assets/icon/bicycle.png"),
    );
  }
}

/// Creates a Map [fills] with the specified geometry for the chosen [routeResponse]
Future<Map<String, Object>> setFills(Map fills, dynamic routeResponse) async {
  return <String, Object>{
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "id": 0,
        "geometry": routeResponse,
      },
    ],
  };
}

/// Adds the journey as a polyline layer to the map
void addFills(MapboxMapController? controller, Map fills, _model) async {
  await controller!.addSource(
      "fills", GeojsonSourceProperties(data: fills)); //creates the line
  await controller.addLineLayer(
    "fills",
    "lines",
    LineLayerProperties(
      lineColor: Color.fromARGB(255, 197, 23, 23).toHexStringRGB(),
      lineCap: "round",
      lineJoin: "round",
      lineWidth: 5,
    ),
  );
  _model.setController(controller); //MOVE THIS OUT OF ADDFILLS -----????
  // await controller.addSymbolLayer(sourceId, layerId, properties)
}

/// Removes the currently displayed polyline layer and destination markers from the map
void removeFills(MapboxMapController? controller, Set<Symbol> polylineSymbols,
    Map fills) async {
  await controller!.removeLayer("lines");
  await controller.removeSource("fills");
  await controller.removeSymbols(polylineSymbols);
  polylineSymbols.clear();
  fills.clear();
}

/// Adds a marker symbol for each multistop destination of a [journey] to the map
void setPolylineMarkers(MapboxMapController controller, List<LatLng> journey,
    Set<Symbol> polylineSymbols) async {
  for (var stop in journey) {
    polylineSymbols.add(await controller.addSymbol(
      SymbolOptions(
          geometry: stop,
          iconSize: 0.1,
          iconImage: "assets/icon/yellow_marker.png"),
    ));
  }
}

/// Removes the multistop destination markers of a [journey] from the map
void removePolylineMarkers(MapboxMapController controller, List<LatLng> journey,
    Set<Symbol> polylineSymbols) async {
  if (polylineSymbols.isNotEmpty) {
    await controller.removeSymbols(polylineSymbols);
    polylineSymbols.clear();
  }
}

//! CLASS VERSION BELOW --- to prevent having to pass in controller for all method calls --- ???

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import '../../models/docking_station.dart';
// import '../../scoped_models/main.dart';

// class MapDrawings {
//   // final MapboxMap map;
//   final MapboxMapController controller;
//   final NavigationModel _model;

//   Map<String, Object> _fills = {};
//   // Symbol? _selectedSymbol; //may remove
//   Set<Symbol> polylineSymbols = {};

//   MapDrawings(this.controller, this._model);

//   void placeDockMarkers(List<DockingStation> docks) {
//     for (var station in docks) {
//       controller.addSymbol(
//         SymbolOptions(
//             geometry: LatLng(station.lat, station.lon),
//             iconSize: 0.7,
//             iconImage: "assets/icon/bicycle.png"),
//       );
//     }
//   }

//   Future<void> setFills(dynamic routeResponse) async {
//     _fills = {
//       "type": "FeatureCollection",
//       "features": [
//         {
//           "type": "Feature",
//           "id": 0,
//           "geometry": routeResponse,
//         },
//       ],
//     };
//   }

//   void addFills(_model) async {
//     await controller.addSource(
//         "fills", GeojsonSourceProperties(data: _fills)); //creates the line
//     await controller.addLineLayer(
//       "fills",
//       "lines",
//       LineLayerProperties(
//         lineColor: Color.fromARGB(255, 197, 23, 23).toHexStringRGB(),
//         lineCap: "round",
//         lineJoin: "round",
//         lineWidth: 5,
//       ),
//     );
//     _model.setController(controller); //MOVE THIS OUT OF ADDFILLS -----
//     // await controller.addSymbolLayer(sourceId, layerId, properties)
//   }

//   void removeFills() async {
//     await controller.removeLayer("lines");
//     await controller.removeSource("fills");
//     //check if symbols aren't null first
//     await controller.removeSymbols(polylineSymbols);
//     polylineSymbols.clear();
//     _fills.clear();

// //REMOVE DOES NOT WORKKKK -- NEED TO CLEAR SOMEHOW
//     // _fills.clear();
//     // polylineSymbols.clear();
//     //removePolylineMarkers();
//   }

//   void setPolylineMarkers(List<LatLng> journey) async {
//     for (var stop in journey) {
//       polylineSymbols.add(await controller.addSymbol(
//         SymbolOptions(
//             geometry: stop,
//             iconSize: 0.1,
//             iconImage: "assets/icon/yellow_marker.png"),
//       ));
//     }
//   }

//   void removePolylineMarkers(List<LatLng> journey) async {
//     //check if symbols aren't null first
//     await controller.removeSymbols(polylineSymbols);
//     polylineSymbols.clear();
//   }
// }
