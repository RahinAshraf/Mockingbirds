import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversions_helpers.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/navigation/polyline_turn_by_turn_screen.dart';
import 'package:veloplan/screens/navigation/turn_by_turn_screen.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/utilities/enums/alert_type.dart';
import 'package:veloplan/widgets/group_id_join_code_widget.dart';
import 'package:veloplan/widgets/popup_widget.dart';

/// Generic popups used thorough the app.
/// Author(s) Marija
/// Contributors: Nicole, Fariha, Rahin, Elisabeth
class Popups {
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
            Navigator.pop(
                context); // pops the alert dialog for join/plan journey
            showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => GroupId()); // pushes PIN alert dialog
          }),
    ];
    return PopupWidget(
        key: Key("proceedTrip"),
        title: "Choose how to proceed with your trip!",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }

  PopupWidget buildPopupDialogRedirect(
      BuildContext context, Itinerary itinerary) {
    List<LatLng> subJourney = convertDocksToLatLng(itinerary.docks!)!;
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        // key: Key("redirect"),
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
        key: Key("info"),
        title:
            "Would you like to be automatically redirected to available stations?",
        text: "Only one way to find out.",
        children: children,
        type: AlertType.question);
  }

  PopupWidget buildPopupDialogJourneySaved(
      BuildContext context, DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedDate = formatter.format(date);

    List<PopupButtonWidget> children = [
      PopupButtonWidget(
          text: "Ok",
          onPressed: () {
            Navigator.pop(context);
          }),
    ];
    return PopupWidget(
        key: Key("suceeded"),
        title: "Journey scheduled successfully!",
        text:
            "Your journey has been scheduled for ${formattedDate}. Check the details in the calendar."
            "\n The closest docking station may vary depending on availability on the day!",
        children: children,
        type: AlertType.warning);
  }

  PopupWidget buildPopupDialogDeleteScheduledJourney(
      BuildContext context, onClick) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(text: "Delete", onPressed: onClick),
      PopupButtonWidget(
          text: "Cancel",
          onPressed: () {
            Navigator.pop(context);
          }),
    ];
    return PopupWidget(
        key: Key("confirm"),
        title: "Confirmation required",
        text: "Are you sure you want to delete this trip?",
        children: children,
        type: AlertType.question);
  }
}
