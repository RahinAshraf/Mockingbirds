import 'dart:async';
import 'dart:math';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';

/// Class to display a mapbox map with on click functionality and other possible widgets
/// Author(s): Fariha Choudhury k20059723, Rahin Ashraf, Nicole

class BaseMapboxClickMap extends BaseMapboxMap {
  late final StreamController<MapPlace> _address;
  final locService = LocationService();

  BaseMapboxClickMap(MapModel model, this._address) : super(model);

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
  }

  @override
  void onMapClick(Point<double> point, LatLng coordinates) async {
    Map s = await locService.reverseGeoCode(
        coordinates.latitude, coordinates.longitude);
    _address.sink.add(MapPlace(s['place'], s['location']));
    print(s['place']);
    print("Latitdue");
    print(s['location'].latitude);
    print(coordinates);
  }
}
