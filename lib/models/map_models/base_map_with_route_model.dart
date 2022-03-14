import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Class to display a mapbox map with a route and other possible widgets
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

class BaseMapboxRouteMap extends BaseMapboxMap {
  late final List<LatLng> _journey;
  Map<String, Object> _fills = {};
  final Set<Symbol> _polylineSymbols = {};
  String _totalDistanceAndTime = 'No route';
  final RouteManager _manager = RouteManager();
  late Map _routeResponse;

  BaseMapboxRouteMap(
      this._journey, bool useLiveLocation, LatLng target, MapModel model)
      : super(useLiveLocation, target, model);

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    _displayJourneyAndRefocus(_journey);
    controller.onSymbolTapped.add(onSymbolTapped);
  }

  /// Display journey and refocus camera position
  void _displayJourneyAndRefocus(List<LatLng> journey) {
    _setJourney(journey);
    _refocusCamera(journey);
    setPolylineMarkers(controller!, journey, _polylineSymbols);
  }

  /// Refocus camera positioning to focus on the [journey] polyline
  void _refocusCamera(List<LatLng> journey) {
    LatLng center = getCenter(journey);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(journey);
    double zoom = getZoom(calculateDistance(center, corners.item1));

    cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// Sets the [journey] geometry
  void _setJourney(List<LatLng> journey) async {
    List<dynamic> journeyPoints = [];
    if (journey.length > 1) {
      _routeResponse = await _manager.getDirections(
          journey[0], journey[1], NavigationType.walking);
      for (int i = 0; i < journey.length - 1; ++i) {
        var directions = await _manager.getDirections(
            journey[i], journey[i + 1], NavigationType.cycling);
        for (dynamic a in directions['geometry']!['coordinates']) {
          journeyPoints.add(a);
        }
        _routeResponse['geometry']
            .update("coordinates", (value) => journeyPoints);
      }
      _displayJourney();
    }
  }

  /// Draws out the journey onto map
  void _displayJourney() async {
    _fills = await setFills(_fills, _routeResponse['geometry']);
    addFills(controller!, _fills, model);
    _setDistanceAndTime();
  }

  /// Sets distance and time
  void _setDistanceAndTime() async {
    try {
      var duration = await _manager.getDistance() as double; //meters
      var distance = await _manager.getDuration() as double; //sec
      _totalDistanceAndTime = "distance: " +
          (distance / 1000).truncate().toString() +
          ", duration: " +
          (duration / 60).truncate().toString();
    } catch (e) {
      _totalDistanceAndTime = "Route not avalible";
    }
  }

  /// Gets the [_totalDistanceAndTime] of a journey
  String _getTotalDistance() {
    return _totalDistanceAndTime;
  }
}
