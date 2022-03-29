import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Class to display a mapbox map with a route and other possible widgets
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

class BaseMapboxRouteMap extends BaseMapboxMap {
  late List<LatLng> _journey;
  final Itinerary _itinerary;
  Map<String, Object> fills = {};
  final Set<Symbol> _polylineSymbols = {};
  final RouteManager manager = RouteManager();
  late Map<dynamic, dynamic> _routeResponse;
  // LatLng _startPosition = getLatLngFromSharedPrefs();

  BaseMapboxRouteMap(this._itinerary, MapModel model) : super(model) {
    _journey = convertDocksToLatLng(_itinerary.docks!)!;
  }

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    await baseMapCreated(controller);
    _displayJourneyAndRefocus(_journey);
  }

  /// Display journey and refocus camera position
  void _displayJourneyAndRefocus(List<LatLng> journey) {
    setBaseJourney(journey);
    _refocusCamera(journey);
    setPolylineMarkers(controller!, journey, _polylineSymbols);
  }

  /// Refocus camera positioning to focus on the [journey] polyline
  void _refocusCamera(List<LatLng> journey) {
    List<LatLng> points = journey;
    points.add(_itinerary.myDestinations![0]);
    LatLng center = getCenter(points);
    Tuple2<LatLng, LatLng> corners = getCornerCoordinates(points);
    double zoom = getZoom(calculateDistance(center, corners.item1));

    cameraPosition = CameraPosition(
        target: center, //target, //center,
        zoom: zoom,
        tilt: 5);
    controller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// Sets the [journey] geometry
  void setBaseJourney(List<LatLng> journey) async {
    List<dynamic> journeyPoints = [];
    double totalDistance = 0.0;
    double totalDuration = 0.0;

    if (journey.length > 1) {
      //WALKING:
      _routeResponse = await manager.getDirections(
          _itinerary.myDestinations![0], journey[0], NavigationType.walking);
      // _routeResponse = await manager.getDirections(
      // _startPosition, journey[0], NavigationType.walking);

      //update local vars ---
      totalDistance += await manager.getDistance() as num;
      totalDuration += await manager.getDuration() as num;
      for (dynamic a in _routeResponse['geometry']!['coordinates']) {
        journeyPoints.add(a);
      }

      for (int i = 0; i < journey.length - 1; ++i) {
        //CYCLING:
        var directions = await manager.getDirections(
            journey[i], journey[i + 1], NavigationType.cycling);

        //update local vars ---
        totalDistance += await manager.getDistance() as num;
        totalDuration += await manager.getDuration() as num;
        for (dynamic a in directions['geometry']!['coordinates']) {
          journeyPoints.add(a);
        }
        _routeResponse['geometry']
            .update("coordinates", (value) => journeyPoints);
        _routeResponse.update("distance", (value) => totalDistance);
        _routeResponse.update("duration", (value) => totalDuration);
      }
      //set distance and duration of whole journey: don't do this if you will reuse distance and duration within this class
      manager.setDistance(_routeResponse['distance']);
      manager.setDuration(_routeResponse['duration']);
      manager.setGeometry(_routeResponse['geometry']);

      displayJourney();
    }
  }

  /// Draws out the journey onto map
  void displayJourney() async {
    fills = await setFills(
        fills,
        manager
            .getGeometry()); //_routeResponse['geometry']); - can use local var instead but i've set it anyway
    addFills(controller!, fills, model);
  }
}
