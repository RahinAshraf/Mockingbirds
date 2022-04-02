import 'package:flutter/material.dart';

/// Author: Rahin Ashraf
class Alerts {
  final String adjacentClosestDocksMessage =
      "Two locations next to each other specify the same docking station.";
  final String fillInLocationBeforeEditingDockMesssage =
      "Please fill in the location you would like to visit, before editing the docking station";
  final String chooseAtLeastOneDestinationMessage =
      "Choose at least one destination to create your journey";
  final String cannotHaveEmptySearchLocationsMessage =
      "Please specify locations for all destinations of the journey. Otherwise, remove any empty choices";
  final String startPointMustBeDefinedMessage =
      "Please specify the starting location of the journey";
  final String noAdjacentLocationsAllowed =
      "You cannot have two places the same after each other";

  /// Shows snack bar error [message] to user.
  void showSnackBarErrorMessage(BuildContext context, message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
