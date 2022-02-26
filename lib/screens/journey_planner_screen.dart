import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../.env.dart';
import '../widget/panel_widget.dart';
import 'map_screen.dart';
import 'location_service.dart';


class MapPlace{
  String? address;
  LatLng? cords;
  MapPlace(this.address, this.cords);
}

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
  final StreamController<MapPlace> address = StreamController.broadcast();
  final StreamController<List<DynamicWidget>> dynamicWidgets =
      StreamController.broadcast();
  final locService = LocationService();

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
    List<MapPlace> mapList = [];
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
                  onMapClick: (Point<double> point, LatLng coordinates) async {
                    Map s = await locService.reverseGeoCode(coordinates.latitude,coordinates.longitude);
                    address.sink.add(MapPlace(s['place'], s['location']));
                    print(s['place']);
                    print("Latitdue");
                    print(s['location'].latitude);
                    print("TEST");
                    print(coordinates);
                  },
                ),
              ),
            ],
          ),
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
          selectionMap: Map(),
          address: address.stream,
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
