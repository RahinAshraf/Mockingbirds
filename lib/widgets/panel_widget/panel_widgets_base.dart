import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/journey_planner_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/dynamic_widget.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget.dart';

/// The base for the panel widget which contains all necessary controllers, streams and data sets.
/// Author: Rahin
abstract class PanelWidgetBase extends StatefulWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  final StreamController<List<DynamicWidget>> dynamicWidgets;
  final List<DynamicWidget> listDynamic;
  final List<List<double?>?> selectedCoords;
  final TextEditingController fromTextEditController;
  final TextEditingController toTextEditController;
  final Stream<MapPlace> address;
  final Map<String, List<double?>> selectionMap;
  final Map<String, List<double?>> staticListMap;
  final int numberOfCyclists;
  final bool isScheduled;
  final DateTime journeyDate;

  const PanelWidgetBase(
      {required this.selectionMap,
      required this.address,
      required this.scrollController,
      required this.dynamicWidgets,
      required this.listDynamic,
      required this.selectedCoords,
      required this.staticListMap,
      required this.toTextEditController,
      required this.fromTextEditController,
      required this.panelController,
      required this.numberOfCyclists,
      required this.isScheduled,
      required this.journeyDate,
      Key? key})
      : super(key: key);

  /// Redirects the user to the [PlaceSearchScreen] in order for them to specify a location to visit for the journey.
  void handleSearchClick(
      PanelWidget widget,
      BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded) async {
    final selectedCoords = widget.selectedCoords;
    final tempPosition = selectedCoords.length;
    final result = await context.openSearch();
    final feature = result as Feature?;
    if (feature != null) {
      textEditingController.text = feature.placeName ?? "N/A";
      final featureCord = feature.geometry?.coordinates;
      if (featureCord != null) {
        onAddressAdded.call(featureCord);
      }
    }
  }
}
