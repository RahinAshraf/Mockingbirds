import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import '../.env.dart';
import '../widgets/panel_widget.dart';
// import 'map_screen.dart';

class JourneyPlanner extends StatefulWidget {
  JourneyPlanner({Key? key}) : super(key: key);

  @override
  _JourneyPlanner createState() => _JourneyPlanner();
}

class _JourneyPlanner extends State<JourneyPlanner> {
  LatLng latLng = getLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  final panelController = PanelController();
  final standAloneSearchController = TextEditingController();
  final StreamController<List<DynamicWidget>> dynamicWidgets =
      StreamController.broadcast();

  List<DynamicWidget> dynamicWidgetList = [];
  List<List<double?>> cordsList = [];

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.6;

    return Scaffold(
      body: SlidingUpPanel(
        padding: const EdgeInsets.only(left: 10, right: 10),
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        parallaxEnabled: true,
        parallaxOffset: .5,
        controller: panelController,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: MapboxMap(
                  accessToken: MAPBOX_ACCESS_TOKEN,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                  minMaxZoomPreference: const MinMaxZoomPreference(14, 17),
                ),
              ),
            ],
          ),
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          listDynamic: dynamicWidgetList,
          textEditingController: standAloneSearchController,
          dynamicWidgets: dynamicWidgets,
          panelController: panelController,
          selectedCords: cordsList,
        ),
      ),
    );
  }
}
