import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/docking_stations_sorting_widget.dart';

/// Edit dock screen displaying map with [DockSorter] panel.
class DockSorterScreen extends StatefulWidget {
  late final LatLng userCoord;
  DockSorterScreen(this.userCoord, {Key? key}) : super(key: key);
  @override
  _DockSorterScreen createState() => _DockSorterScreen();
}

class _DockSorterScreen extends State<DockSorterScreen> {
  final panelController = PanelController();
  late LatLng userCoordinates;
  late BaseMapboxMap _baseMap;

  @override
  void initState() {
    userCoordinates = super.widget.userCoord;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.35;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.35;
    return Scaffold(
      body: SlidingUpPanel(
        padding: const EdgeInsets.only(left: 10, right: 10),
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        controller: panelController,
        body: ScopedModelDescendant<MapModel>(
            builder: (BuildContext context, Widget? child, MapModel model) {
          _baseMap = BaseMapboxMap(model);
          return Stack(children: _baseMap.getWidgets());
        }),
        panelBuilder: (controller) =>
            DockSorter(userCoordinates, controller: controller),
      ),
    );
  }
}
