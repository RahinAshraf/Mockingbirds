import 'package:flutter/material.dart';

class Alerts {
  // Show error message to user for having no destinations specified for the journey
  void showAtLeastOneDestinationSnackBar(BuildContext context) {
    const text = "Choose at least one destination to create your journey";
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(text)));
  }

  // Show error message to user for having blank destination fields
  void showWhereToTextFieldsMustNotBeEmptySnackBar(BuildContext context) {
    const text =
        "Please specify locations for all destinations of the journey. Otherwise, remove any empty choices";
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(text)));
  }

  // Show error message to user for not specifying the starting point of the journey
  void showStartLocationMustNotBeEmptySnackBar(BuildContext context) {
    const text = "Please specify the starting location of the journey";
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(text)));
  }

  // Show error message to user for specifying the same destination locations one after another
  void showCantHaveAdjacentSnackBar(BuildContext context) {
    const text = "You cannot have two places the same after each other";
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(text)));
  }
}
