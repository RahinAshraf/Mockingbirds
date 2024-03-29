import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_helpers.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/models/map_models/base_map_with_route_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/popups.dart';
import 'package:veloplan/styles/colors.dart';

/// Map screen showing and focusing on a a selected journey
/// Author(s): Elisabeth Halvorsen k20077737,
/// Contributor(s): Fariha Choudhury k20059723

class MapRoutePage extends StatefulWidget {
  final Itinerary _itinerary;
  MapRoutePage(this._itinerary);

  @override
  _MapRoutePageState createState() => _MapRoutePageState(this._itinerary);
}

class _MapRoutePageState extends State<MapRoutePage> {
  LatLng currentLatLng = getLatLngFromSharedPrefs();
  late BaseMapboxRouteMap _baseMapWithRoute;
  final Itinerary _itinerary;
  _MapRoutePageState(this._itinerary) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScopedModelDescendant<MapModel>(
        builder: (BuildContext context, Widget? child, MapModel model) {
      _baseMapWithRoute = BaseMapboxRouteMap(_itinerary, model);
      addPositionZoom();
      addGoBackButton();
      addStopPolylineRoute(context);
      if (calculateDistance(currentLatLng, _itinerary.myDestinations![0]) <
          0.02) {
        startTurnByTurn(context, _itinerary);
      }

      return SafeArea(child: Stack(children: _baseMapWithRoute.getWidgets()));
    }));
  }

  /// add positional zoom to our widgets
  void addPositionZoom() {
    _baseMapWithRoute.addWidget(Container(
      alignment: Alignment(0.9, 0.90),
      child: FloatingActionButton(
        heroTag: "center_to_current_loaction",
        onPressed: () {
          _baseMapWithRoute.controller?.animateCamera(
              CameraUpdate.newCameraPosition(_baseMapWithRoute.cameraPosition));
        },
        child: const Icon(Icons.my_location),
        backgroundColor: CustomColors.green,
      ),
    ));
  }

  /// adds turn a turn by turn to our list of widgets
  void startTurnByTurn(BuildContext context, Itinerary itinerary) {
    Popups popup = new Popups();
    _baseMapWithRoute.addWidget(Container(
      alignment: Alignment(0.9, 0.7),
      child: FloatingActionButton(
        heroTag: "start_turn_by_trun",
        onPressed: () {
          showDialog(
              useRootNavigator: false,
              context: context,
              builder: (BuildContext context) =>
                  popup.buildPopupDialogRedirect(context, itinerary));
        },
        child: const Text("GO"),
        backgroundColor: CustomColors.green,
      ),
    ));
  }

  /// add a reroute button to navbar
  void addGoBackButton() {
    _baseMapWithRoute.addWidget(Container(
      alignment: Alignment(-0.9, -0.80),
      child: FloatingActionButton(
        heroTag: "back",
        onPressed: () {
          try {
            Navigator.of(context).pop(true);
          } catch (e) {
            log("failed to push replacement");
          }
        },
        child: const Icon(Icons.arrow_back, key: Key("back")),
        backgroundColor: Colors.white,
      ),
    ));
  }

  /// Add a stop polyline route button to the screen.
  void addStopPolylineRoute(BuildContext context) {
    _baseMapWithRoute.addWidget(
      Container(
        alignment: Alignment(0.9, -0.80),
        child: FloatingActionButton(
          heroTag: "stop_polyline",
          onPressed: () {
            try {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } catch (e) {
              log("Failed to push replacement");
            }
          },
          child: const Icon(
            Icons.close_rounded,
          ),
          backgroundColor: CustomColors.orange,
        ),
      ),
    );
  }
}
