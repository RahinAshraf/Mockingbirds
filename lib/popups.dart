import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/screens/navigation/polyline_turn_by_turn.dart';
import 'package:veloplan/screens/navigation/turn_by_turn_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/widgets/group_id_join_code_widget.dart';
import 'package:veloplan/widgets/popup_widget.dart';
import 'package:veloplan/utilities/alert_type.dart';

import 'helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'models/itinerary.dart';

/// Generic popups used thorough the app
/// Author(s) Marija
/// Contributors: Nicole

class Popups {
  // Questions
  PopupWidget buildPopupDialogNewJourney(BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        text: "Plan a journey",
        onPressed: () async {
          final response = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => TripSchedulerScreen()));
          if (response || response == null) {
            Navigator.of(context).pop(true);
          }
        },
      ),
      PopupButtonWidget(
          text: "Join a journey",
          onPressed: () {
            Navigator.pop(context);
            showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => GroupId());
          }),
    ];
    return PopupWidget(
        title: "Choose how to proceed with your trip!",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }

  PopupWidget buildPopupDialogTripExceedsTime(BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Edit Journey", onPressed: () {}),
      PopupButtonWidget(text: "Continue", onPressed: () {}),
    ];
    return PopupWidget(
        title: "Are you sure you want to proceed?",
        text: "Your trip exceeds 30 minutes.",
        children: children,
        type: AlertType.question);
  }

  PopupWidget buildPopupDialogIntermediateTripExceedsTime(
      BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Edit Journey", onPressed: () {}),
      PopupButtonWidget(text: "Continue", onPressed: () {}),
    ];
    return PopupWidget(
        title: "Are you sure you want to proceed?",
        text: "Your intermediate trip exceeds 30 minutes.",
        children: children,
        type: AlertType.question);
  }

  // Warnings
  PopupWidget buildPopupDialogStationAvailabilityIsPredicted(
      BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Return", onPressed: () {}),
      PopupButtonWidget(text: "Continue", onPressed: () {}),
    ];
    return PopupWidget(
        title: "The docking station availability is predicted!",
        text: "It may not be accurate the day of the journey.",
        children: children,
        type: AlertType.warning);
  }

  PopupWidget buildPopupDialogJourneyStartingSoon(BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Leave", onPressed: () {}),
    ];
    return PopupWidget(
        title: "Journey starting soon!",
        text: "You will be redirected automatically.",
        children: children,
        type: AlertType.warning);
  }

  PopupWidget buildWeather(BuildContext context, weather, weatherIcon) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Leave", onPressed: () {}),
    ];
    return PopupWidget(
        title: "Weather",
        text: "You will be redirected automatically.",
        children: [],
        type: AlertType.warning);
  }

  PopupWidget buildPopupDialogRedirect(
      BuildContext context, Itinerary itinerary) {
    List<LatLng> subJourney = convertDocksToLatLng(itinerary.docks!)!;
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        text: "Yes, redirect me",
        onPressed: () async {
          final response = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapUpdatedRoutePage(itinerary)));
          if (response || response == null || !response) {
            Navigator.of(context).pop(true);
          }
        },
      ),
      PopupButtonWidget(
          text: "No, don't redirect me",
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TurnByTurn(latLngs2WayPoints(subJourney))));
          }),
    ];
    return PopupWidget(
        title:
            "Would you like to be automatically redirected to available stations?",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }
}
