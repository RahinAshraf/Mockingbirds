import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../models/docking_station.dart';

/// Helper methods related to adding layers to the map
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

/// Creates a [fills] Map with the specified geometry for the chosen [routeResponse]
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

/// Adds symbol layer to map for every docking station in London
void placeDockMarkers(MapboxMapController controller,
    List<DockingStation> docks, Set<Symbol> dockSymbols) async {
  for (var station in docks) {
    // dockSymbols.add(await controller.addSymbol(
    //     SymbolOptions(
    //         geometry: LatLng(station.lat, station.lon),
    //         iconSize: 0.7,
    //         iconImage: "assets/icon/bicycle.png"),
    //     {
    //       "station": station,
    //     }));
    addDockSymbol(
        controller, dockSymbols, station, "assets/icon/bicycle.png", 0.7);
  }
}

/// Adds marker symbols for each location of a [journey] list to the map, using [LatLng]s
void setPolylineMarkers(MapboxMapController controller, List<LatLng> journey,
    Set<Symbol> polylineSymbols) async {
  for (var stop in journey) {
    addSymbol(controller, polylineSymbols, stop,
        "assets/icon/yellow_marker.png", 0.1);

    // polylineSymbols.add(await controller.addSymbol(
    //   SymbolOptions(
    //       geometry: stop,
    //       iconSize: 0.1,
    //       iconImage: "assets/icon/yellow_marker.png"),
    // ));
  }
}

/// Set markers for docking stations using yellow marker using [DockingStation]s.
void setMarkers(MapboxMapController controller, List<DockingStation> docks,
    Set<Symbol> symbolsSet) async {
  for (var station in docks) {
    addDockSymbol(
        controller, symbolsSet, station, "assets/icon/yellow_marker.png", 0.1);
    // symbolsSet.add(await controller.addSymbol(
    //     SymbolOptions(
    //         geometry: LatLng(station.lat, station.lon),
    //         iconSize: 0.1,
    //         iconImage: "assets/icon/yellow_marker.png"),
    //     {
    //       "station": station,
    //     }));

  }
}

/// Adds marker symbol for a single [point] to the map in its own set
void setMarker(MapboxMapController controller, LatLng point,
    Set<Symbol> currentSymbol) async {
  addSymbol(controller, currentSymbol, point, "assets/icon/bicycle.png", 0.7);
  // currentSymbol.add(await controller.addSymbol(
  //   SymbolOptions(
  //       geometry: point, iconSize: 0.7, iconImage: "assets/icon/bicycle.png"),
  // ));
}

///// ADDS SYMBOL LAYERS TO CONTROLLER:
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

void addSymbol(MapboxMapController controller, Set<Symbol> symbolsSet,
    LatLng location, String marker, double iconSize) async {
  symbolsSet.add(await controller.addSymbol(
    SymbolOptions(geometry: location, iconSize: iconSize, iconImage: marker),
  ));
}

/// Removes the specified location markers [polylineSymbols] from the map
void removePolylineMarkers(
    MapboxMapController controller, Set<Symbol> polylineSymbols) async {
  if (polylineSymbols.isNotEmpty) {
    await controller.removeSymbols(polylineSymbols);
    polylineSymbols.clear();
  }
}

///TO DO:
///Separate 'setDockMarkers' from 'setLocationMarkers'
///dock takes docking station, location takes LatLng
