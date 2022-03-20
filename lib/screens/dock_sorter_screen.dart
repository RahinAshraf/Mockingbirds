import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/screens/navigation/map_screen.dart';
import '../.env.dart';
import '../widgets/docking_stations_sorting_widget.dart';
import 'navigation/map_screen.dart';

class DockSorterScreen extends StatefulWidget {
  late final LatLng userCoord;
  DockSorterScreen(this.userCoord, {Key? key}) : super(key: key);

  @override
  _DockSorterScreen createState() => _DockSorterScreen();
}

class _DockSorterScreen extends State<DockSorterScreen> {
  late CameraPosition _initialCameraPosition;
  LatLng latLng = getLatLngFromSharedPrefs();
  late MapboxMapController controller;
  final panelController = PanelController();
  late LatLng userCoordinates;

  @override
  void initState() {
    userCoordinates = super.widget.userCoord;
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: zoom);
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.4;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.4;
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
                ),
              ),
            ],
          ),
        ),
        panelBuilder: (controller) =>
            DockSorter(userCoordinates, controller: controller),
      ),
    );
  }
}
