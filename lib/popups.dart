import 'package:flutter/material.dart';
import 'package:veloplan/screens/trips_scheduler_screen.dart';
import 'package:veloplan/widgets/popup_widget.dart';

class Popups {
  // Questions
  PopupWidget buildPopupDialogNewJourney(BuildContext context) {
    List<PopupButtonWidget> children = [
      PopupButtonWidget(
        text: "Plan a journey",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TripScheduler()));
        },
      ),
      PopupButtonWidget(text: "Join a journey", onPressed: () {}),
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
}
