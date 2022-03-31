import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../models/docking_station.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';

/// Helper methods related to adding layers to the map
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
final GlobalKey<DockStationState> dockingStationKey = GlobalKey();

/// Adds symbol layer to map for every docking station in London
// void placeDockMarkers(
//     MapboxMapController controller, List<DockingStation> docks) {
//   for (var station in docks) {
//     controller.addSymbol(
//         SymbolOptions(
//             geometry: LatLng(station.lat, station.lon),
//             iconSize: 0.3,
//             iconImage: "assets/images/appicon.png"),
//         {
//           "station": station,
//         });
//   }
// }

/// Creates a [fills] Map with the specified geometry for the chosen [routeResponse]
Future<Map<String, Object>> setFills(Map fills, dynamic routeResponse) async {
  try {
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
  } catch (e) {
    return {};
  }
}

/// Adds the journey as a polyline layer to the map
void addFills(MapboxMapController? controller, Map fills, _model) async {
  try {
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
  } catch (e) {}
}

/// Removes the currently displayed polyline layer and destination markers from the map
void removeFills(MapboxMapController? controller, Set<Symbol> polylineSymbols,
    Map fills) async {
  try {
    await controller!.removeLayer("lines");
    await controller.removeSource("fills");
    await controller.removeSymbols(polylineSymbols);
    polylineSymbols.clear();
    fills.clear();
  } catch (e) {}
}

/// DOCK DATA SYMBOLS -- docking station data

/// Adds symbol layer to map for every docking station in London
void placeDockMarkers(MapboxMapController controller,
    List<DockingStation> docks, Set<Symbol> dockSymbols) async {
  for (var station in docks) {
    addDockSymbol(
        controller, dockSymbols, station, "assets/images/appicon.png", 0.19);
  }
}

/// Set markers for docking stations using yellow marker using [DockingStation]s.
void setYellowMarkers(MapboxMapController controller,
    List<DockingStation> docks, Set<Symbol> symbolsSet) async {
  for (var station in docks) {
    addDockSymbol(
        controller, symbolsSet, station, "assets/icon/yellow_marker.png", 0.1);
  }
}

void setRedMarkers(MapboxMapController controller, List<DockingStation> docks,
    Set<Symbol> symbolsSet) async {
  for (var station in docks) {
    addDockSymbol(
        controller, symbolsSet, station, "assets/icon/red_marker.png", 0.1);
  }
}

///// ADDS SYMBOL LAYERS TO CONTROLLER WITH BIKE INFO :
/// Adds marker
void addDockSymbol(MapboxMapController controller, Set<Symbol> symbolsSet,
    DockingStation station, String marker, double iconSize) async {
  symbolsSet.add(await controller.addSymbol(
      SymbolOptions(
          geometry: LatLng(station.lat, station.lon),
          iconSize: iconSize,
          iconImage: marker),
      {
        "station": station,
      }));
}

/// Adds marker symbols for each location of a [journey] list to the map, using [LatLng]s
void setLocationMarkers(MapboxMapController controller, List<LatLng> journey,
    Set<Symbol> polylineSymbols) async {
  for (var stop in journey) {
    addSymbol(controller, polylineSymbols, stop,
        "assets/icon/yellow_marker.png", 0.1);
  }
}

/// Adds marker symbol for a single [point] to the map and the [currentSymbol] set
// void setMarker(MapboxMapController controller, LatLng point,
//     Set<Symbol> currentSymbol) async {
//   addSymbol(
//       controller, currentSymbol, point, "assets/icon/yellow_marker.png", 0.1);
// }

/// Adds a symbol to the [MapBoxController] and [symbolsSet] with the given [marker] and [iconSize]
void addSymbol(MapboxMapController controller, Set<Symbol> symbolsSet,
    LatLng location, String marker, double iconSize) async {
  symbolsSet.add(await controller.addSymbol(
    SymbolOptions(geometry: location, iconSize: iconSize, iconImage: marker),
  ));
}

/// Removes the specified location markers [polylineSymbols] from the map
// void removePolylineMarkers(
//     MapboxMapController controller, Set<Symbol> polylineSymbols) async {
//   if (polylineSymbols.isNotEmpty) {
//     await controller.removeSymbols(polylineSymbols);
//     polylineSymbols.clear();
//   }
// }

///Removes all markers from the map that are in [removeMarkerSet] and clears the set
void removeMarkers(
    MapboxMapController controller, Set<Symbol> removeMarkerSet) async {
  if (removeMarkerSet.isNotEmpty) {
    await controller.removeSymbols(removeMarkerSet);
    removeMarkerSet.clear();
  }
}

///REMOVE THIS
/// Removes the multistop destination markers of a [journey] from the map
void removePolylineMarkers(MapboxMapController controller, List<LatLng> journey,
    Set<Symbol> polylineSymbols) async {
  if (polylineSymbols.isNotEmpty) {
    try {
      await controller.removeSymbols(polylineSymbols);
      polylineSymbols.clear();
    } catch (e) {}
  }
}
