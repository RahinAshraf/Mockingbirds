import 'dart:async';
import 'dart:math';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tuple/tuple.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/providers/route_manager.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/helpers/navigation_helpers/map_drawings.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/utilities/travel_type.dart';

/// Class to display a mapbox map with a route and other possible widgets
/// Author(s): Fariha Choudhury k20059723, Elisabeth Koren Halvorsen k20077737

class BaseMapboxClickMap extends BaseMapboxMap {
  late StreamController<MapPlace> _address; //= StreamController.broadcast();
  final locService = LocationService();

  BaseMapboxClickMap(MapModel model, this._address) : super(model);

  /// Initialise map features
  @override
  void onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
    model.setController(controller);
    // model.fetchDockingStations();
    // _displayJourneyAndRefocus(_journey);
    // controller.onSymbolTapped.add(onSymbolTapped);
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
