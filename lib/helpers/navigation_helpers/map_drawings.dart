import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../models/docking_station.dart';
import 'package:veloplan/widgets/docking_station_widget.dart';

/// Helper methods related to adding layers to the map
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737
final GlobalKey<DockStationState> dockingStationKey = GlobalKey();

/// Adds symbol layer to map for every docking station in London
void placeDockMarkers(
    MapboxMapController controller, List<DockingStation> docks) {
  for (var station in docks) {
    controller.addSymbol(
        SymbolOptions(
            geometry: LatLng(station.lat, station.lon),
            iconSize: 0.3,
            iconImage: "assets/images/appicon.png"),
        {
          "station": station,
        });
  }
}

// Widget displayDockCard(DockingStation station) {
//   //CHANGE THIS TO CREATE CARD
//   print("Will call widget next");
//   // return _DockPopupCard(latlng: current,);
//   dockingStationKey.currentState
//       ?.setData(DockingStationCard.station(station), true);
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

/// Adds marker symbols for each multistop destination of a [journey] to the map
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
    try {
      await controller.removeSymbols(polylineSymbols);
      polylineSymbols.clear();
    } catch (e) {}
  }
}
