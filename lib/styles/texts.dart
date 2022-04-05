import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle headline1 = TextStyle(
      fontSize: 30.0,
      color: Color(0xFF393939),
      fontWeight: FontWeight.w700,
      fontFamily: 'Montserrat');

  static TextStyle headline2 = TextStyle(
      fontSize: 20.0,
      color: Color(0xFF393939),
      fontWeight: FontWeight.w700,
      fontFamily: 'Montserrat');

  static TextStyle placeholderText = TextStyle(
      color: Colors.black,
      fontStyle: FontStyle.italic,
      fontSize: 15,
      fontFamily: 'Montserrat');

  // Events and Docking Station Cards
  static TextStyle eventCardDetailsTextStyle =
      TextStyle(fontSize: 15.0, color: Colors.black54);

  static TextStyle dockingStationCardTextStyle = TextStyle(
    fontSize: 15.0,
    color: Color(0xFF99D2A9),
    fontWeight: FontWeight.w700,
  );

  static TextStyle dockingStationCardNameStyle = TextStyle(
      fontSize: 16.0, color: Color(0xFF99D2A9), fontWeight: FontWeight.w500);

  // Popups
  static TextStyle popupDialogTextStyle = TextStyle(
      color: Color(0xffD3DAE0), fontWeight: FontWeight.w600, fontSize: 18.0);

  static TextStyle popupDialogTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    color: Color(0xFF7C8691),
  );

  static TextStyle popupDialogButtonTextStyle =
      TextStyle(fontSize: 18.0, color: Colors.white);

  // Authorisation (login, signup, email validation)
  static TextStyle authTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15);

// Trips scheduler panel widget
  static TextStyle infoTextStyle =
      TextStyle(fontStyle: FontStyle.italic, fontSize: 18);
  static TextStyle tripSchedulerTextStyle =
      TextStyle(fontWeight: FontWeight.normal, fontSize: 18);
  static TextStyle cyclistNumberTextStyle =
      TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500);

  // HelpBot
  static TextStyle messageAuthorTextStyle =
      TextStyle(fontSize: 13.0, color: Colors.black54);
  static TextStyle botMessageTextStyle =
      TextStyle(fontSize: 15.0, color: Colors.black54);
  static TextStyle userMessageTextStyle =
      TextStyle(fontSize: 15.0, color: Colors.white);

  // Timeline in Summary of Journey
  static TextStyle timelinePathInfo = TextStyle(
      fontSize: 13.0,
      color: Colors.black54,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat');

  // Styling for favourites and past journeys sidebar
  static TextStyle sidebarTextStyle = TextStyle(
      fontSize: 20.0,
      color: (Color(0xFF99D2A9)),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      fontFamily: 'Montserrat');

// Styling for weather
  static TextStyle weatherTextStyle = TextStyle(
      fontSize: 25.0,
      color: (Color(0xFF99D2A9)),
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic);

  static TextStyle organiserSubtitleText = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      fontFamily: 'Montserrat');
}
