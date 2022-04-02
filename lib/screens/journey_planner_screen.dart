import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/helpers/shared_prefs.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/models/map_models/base_map_model.dart';
import '../widgets/panel_widget/panel_widget.dart';
import '../providers/location_service.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veloplan/scoped_models/map_model.dart';
import 'package:veloplan/widgets/dynamic_widget.dart';

/// Author(s): Rahin Ashraf
/// The place on the Map
class MapPlace {
  String? address;
  LatLng? coords;

  MapPlace(this.address, this.coords);
}

///The screen in the app where the user specifies the locations they wish to visit in London on their trip
class JourneyPlanner extends StatefulWidget {
  final int? numberOfCyclists;
  final DateTime? journeyDate;
  final bool isScheduled;

  JourneyPlanner({
    Key? key,
    this.numberOfCyclists,
    this.journeyDate,
    this.isScheduled = false,
  }) : super(key: key);

  @override
  _JourneyPlanner createState() => _JourneyPlanner();
}

class _JourneyPlanner extends State<JourneyPlanner> {
  LatLng latLng = getLatLngFromSharedPrefs();
  final panelController = PanelController();
  final fromTextEditingController = TextEditingController(),
      toTextEditingController = TextEditingController();
  final StreamController<MapPlace> address = StreamController.broadcast();
  final StreamController<List<DynamicWidget>> dynamicWidgets =
      StreamController.broadcast();
  final locService = LocationService();
  late BaseMapboxMap _baseMap;

  List<DynamicWidget> dynamicWidgetList = [];
  List<List<double?>> coordsList = [];
  Map<int, DockingStation> dockList = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<double?>> staticCordMap = {};
    Map<String, List<double?>> staticDockMap = {};
    print("numberOfCyclists: ${widget.numberOfCyclists}");

    return Scaffold(
        body: Stack(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        child: ScopedModelDescendant<MapModel>(
            builder: (BuildContext context, Widget? child, MapModel model) {
          _baseMap = BaseMapboxMap(model, address: address);
          return SafeArea(child: Stack(children: _baseMap.getWidgets()));
        }),
      ),
      Positioned.fill(
        top: MediaQuery.of(context).size.height * 0.40,
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: PanelWidget(
            scrollController: ScrollController(),
            selectionMap: Map(),
            address: address.stream,
            listDynamic: dynamicWidgetList,
            fromTextEditController: fromTextEditingController,
            toTextEditController: toTextEditingController,
            dynamicWidgets: dynamicWidgets,
            panelController: panelController,
            numberOfCyclists: widget.numberOfCyclists ?? 1,
            selectedCoords: coordsList,
            staticListMap: staticCordMap,
            dockingStationMap: dockList,
            isScheduled: widget.isScheduled,
            journeyDate: widget.journeyDate!,
          ),
        ),
      ),
    ]));
  }
}
