import 'package:flutter/material.dart';

class Alerts {

  //Show error message to user for having no destinations specified for the journey
  void showAllDestinationsHaveTheSameDockingStationSetAsClosest(BuildContext context) {
    const text = "showAllDestinationsHaveTheSameDockingStationSetAsClosest";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Show error message to user for having no destinations specified for the journey
  void showPlaceLocationMustBeSpecifiedBeforeEditingDocks(BuildContext context) {
    const text = "Please fill in the location you would like to visit, before editing the docking station";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Show error message to user for having no destinations specified for the journey
  void showAtLeastOneDestinationSnackBar(BuildContext context) {
    const text = "Choose at least one destination to create your journey";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Show error message to user for having blank destination fields
  void showWhereToTextFieldsMustNotBeEmptySnackBar(BuildContext context) {
    const text =
        "Please specify locations for all destinations of the journey. Otherwise, remove any empty choices";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Show error message to user for not specifying the starting point of the journey
  void showStartLocationMustNotBeEmptySnackBar(BuildContext context) {
    const text = "Please specify the starting location of the journey";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showCantHaveAdajcentSnackBar(BuildContext context) {
    const text = "You cannot have two places the same after each other";
    const snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
