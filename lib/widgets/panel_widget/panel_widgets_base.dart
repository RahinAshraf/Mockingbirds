import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:veloplan/alerts.dart';
import 'package:veloplan/utilities/dart_exts.dart';
import 'package:veloplan/widgets/panel_widget/panel_widget.dart';
import '../../providers/location_service.dart';
import '../../screens/journey_planner_screen.dart';
import '../dynamic_widget.dart';

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
        Key? key})
      : super(key: key);

  //When triggered, redirects the user to the place_search_Screen in order for them to specify a location to visit
  //for the journey

  void handleSearchClick(
      PanelWidget widget,
      BuildContext context,
      TextEditingController textEditingController,
      Function(List<double?>) onAddressAdded) async {
    final selectedCoords = widget.selectedCoords;
    final tempPosition = selectedCoords.length;
    final result = await context.openSearch();
    print("Navigator_Navigator_Navigator => $tempPosition");
    final feature = result as Feature?;
    if (feature != null) {
      textEditingController.text = feature.placeName ?? "N/A";
      final featureCord = feature.geometry?.coordinates;
      if (featureCord != null) {
        onAddressAdded.call(featureCord);
      }
    }
  }

  //The logic to restrict the user from being able to start a journey without defining at least one destination for the journey
  bool oneDestinationMustBeSpecified( PanelWidget widget,
      BuildContext context, Alerts alert) {
    if (widget.listDynamic.isEmpty) {
      alert.showAtLeastOneDestinationSnackBar(context);
      return true;
    }
    return false;
  }

}

