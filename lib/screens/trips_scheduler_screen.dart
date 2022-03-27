import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/.env.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../.env.dart';
import '../widgets/trips_scheduler_panel_widget.dart';

class TripScheduler extends StatefulWidget {
  const TripScheduler({Key? key}) : super(key: key);

  @override
  _TripScheduler createState() => _TripScheduler();
}

//TODO: Marija extend the base map again
class _TripScheduler extends State<TripScheduler> {
  late CameraPosition _initialCameraPosition;
  LatLng latLng = getLatLngFromSharedPrefs();
  late MapboxMapController controller;
  final panelController = PanelController();

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: latLng, zoom: 16);
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
        panelBuilder: (controller) => PanelWidgetTripScheduler(
          controller: controller,
        ),
      ),
    );
  }
}
