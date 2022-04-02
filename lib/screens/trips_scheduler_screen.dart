import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/trips_scheduler_panel_widget.dart';

/// Trip scheduler screen displaying map with [TripSchedulerPanelWidget] panel.
class TripSchedulerScreen extends StatefulWidget {
  const TripSchedulerScreen({Key? key}) : super(key: key);
  @override
  _TripSchedulerScreenState createState() => _TripSchedulerScreenState();
}

class _TripSchedulerScreenState extends State<TripSchedulerScreen> {
  final panelController = PanelController();
  late BaseMapboxMap _baseMap;

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
        body: ScopedModelDescendant<MapModel>(
            builder: (BuildContext context, Widget? child, MapModel model) {
          _baseMap = BaseMapboxMap(model);
          return Stack(children: _baseMap.getWidgets());
        }),
        panelBuilder: (controller) => TripSchedulerPanelWidget(),
      ),
    );
  }

  // _onMapCreated(MapboxMapController controller) async {
  //   this.controller = controller;
  // }
}
