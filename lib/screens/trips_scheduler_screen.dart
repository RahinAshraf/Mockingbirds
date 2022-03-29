import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:veloplan/widgets/trips_scheduler_panel_widget.dart';

class TripSchedulerScreen extends StatefulWidget {
  const TripSchedulerScreen({Key? key}) : super(key: key);
  @override
  _TripSchedulerScreenState createState() => _TripSchedulerScreenState();
}

class _TripSchedulerScreenState extends State<TripSchedulerScreen> {
  late CameraPosition _initialCameraPosition;
  late MapboxMapController controller;
  final panelController = PanelController();
  LatLng latLng = getLatLngFromSharedPrefs();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 16);
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.30;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.30;
    return Scaffold(
      body: SlidingUpPanel(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
        panelBuilder: (controller) => TripSchedulerPanelWidget(),
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }
}
