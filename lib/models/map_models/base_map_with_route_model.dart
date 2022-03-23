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
  final Set<Symbol> polylineSymbols = {};
  String _totalDistanceAndTime = 'No route';
  final RouteManager _manager = RouteManager();
  late Map _routeResponse;
  late bool _displayPolyline;

  // BaseMapboxRouteMap(this._journey, MapModel model) : super(model);
  BaseMapboxRouteMap(this._journey, MapModel model,
      this._displayPolyline) //ADD BOOLEAN FOR DISPLAYING POLYLINE SO CAN REUSE FOR ONLY MARKERS - remove it now
      : super(model);

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    model.fetchDockingStations();
    _displayJourneyAndRefocus(_journey);
    onMarkerTapped(controller);
    //controller.onSymbolTapped.add(onSymbolTapped);  --- no tapping functionality for route model
  }

  /// Calls [onSymbolTapped] functionality for docking station markers on maps that do not [_displayPolyline]
  void onMarkerTapped(MapboxMapController controller) {
    // if (!_displayPolyline) {
    //   controller.onSymbolTapped.add(onSymbolTapped);
    // }
  }

  /// Retrieves the [stationData] of the docking station [symbol] that was tapped
  @override
  Future<void> onSymbolTapped(Symbol symbol) async {}

  /// Display journey and refocus camera position
  void _displayJourneyAndRefocus(List<LatLng> journey) {
    // if (_displayPolyline) {
    _setJourney(journey);
    // }
    //_setJourney(journey);
    _refocusCamera(journey);
    setPolylineMarkers(controller!, journey, polylineSymbols);
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
    // vars used to collect data for WHOLE journey; incremented by vars of each sub journey AB, BC etc.
    List<dynamic> journeyPoints = [];
    double totalDistance = 0.0;
    double totalDuration = 0.0;

    if (journey.length > 1) {
      //WALKING:
      _routeResponse = await _manager.getDirections(
          journey[0], journey[1], NavigationType.walking);

      //update local vars ---
      totalDistance += await _manager.getDistance() as num;
      totalDuration += await _manager.getDuration() as num;
      for (dynamic a in _routeResponse['geometry']!['coordinates']) {
        journeyPoints.add(a);
      }

      for (int i = 1; i < journey.length - 1; ++i) {
        //CYCLING:
        var directions = await _manager.getDirections(
            journey[i], journey[i + 1], NavigationType.cycling);

        //update local vars ---
        totalDistance += await _manager.getDistance() as num;
        totalDuration += await _manager.getDuration() as num;
        for (dynamic a in directions['geometry']!['coordinates']) {
          journeyPoints.add(a);
        }
        _routeResponse['geometry']
            .update("coordinates", (value) => journeyPoints);
        _routeResponse.update("distance", (value) => totalDistance);
        _routeResponse.update("duration", (value) => totalDuration);
      }
      //set distance and duration of whole journey: don't do this if you will reuse distance and duration within this class
      _manager.setDistance(_routeResponse['distance']);
      _manager.setDuration(_routeResponse['duration']);
      _manager.setGeometry(_routeResponse['geometry']);

      _displayJourney();
    }
  }

  /// Draws out the journey onto map
  void _displayJourney() async {
    _fills = await setFills(
        _fills,
        _manager
            .getGeometry()); //_routeResponse['geometry']); - can use local var instead but i've set it anyway
    addFills(controller!, _fills, model);
    _setDistanceAndTime();
  }

  /// Sets distance and time
  void _setDistanceAndTime() async {
    try {
      var distance = await _manager.getDistance() as double; //meters
      var duration = await _manager.getDuration() as double; //sec

      _totalDistanceAndTime = "distance: " +
          (distance / 1000).truncate().toString() +
          "km, duration: " +
          (duration / 60).truncate().toString();
      print(_totalDistanceAndTime);
    } catch (e) {
      _totalDistanceAndTime = "Route not available";
    }
  }

  /// Gets the [_totalDistanceAndTime] of a journey
  String _getTotalDistance() {
    return _totalDistanceAndTime;
  }
}
