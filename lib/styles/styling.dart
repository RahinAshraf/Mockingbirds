import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Author: Marija
// Contributor: Hristina-Andreea Sararu, K20036771
// General
const Color whiteReplacement =
    Color(0xFFf5f5f5); // replacement for bright white color

// Helpbot and message bubbles
const Color userMessageBubbleColor = Color(0xFF99D2A9);
const Color botMessageBubbleColor = Colors.white;
const TextStyle messageAuthorTextStyle =
    TextStyle(fontSize: 13.0, color: Colors.black54);
const TextStyle botMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.black54);
const TextStyle userMessageTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.white);
const Color helpScreenBorderColor = Color(0x4D99D2A9);

// Popup dialogs
const TextStyle popupDialogTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 24.0, color: Color(0xFF7C8691));
const TextStyle popupDialogTextStyle = TextStyle(
    color: Color(0xffD3DAE0), fontWeight: FontWeight.w600, fontSize: 18.0);
ButtonStyle popupDialogButtonStyle = ButtonStyle(
    overlayColor: MaterialStateProperty.all(Colors.green.shade200),
    backgroundColor: MaterialStateProperty.all(const Color(0XFFFBAB4B)),
    padding: MaterialStateProperty.all(
        const EdgeInsets.only(right: 10.0, left: 10.0)));
const TextStyle popupDialogButtonTextStyle =
    TextStyle(fontSize: 18.0, color: Colors.white);

// Authorisation (login, signup, email validation)
const authTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15);
const welcomeTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 25);

// Trips scheduler panel widget
const TextStyle infoTextStyle =
    TextStyle(fontStyle: FontStyle.italic, fontSize: 18);
const TextStyle tripSchedulerTextStyle =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 18);
const TextStyle cyclistNumberTextStyle =
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500);

// Styling for schedule page
const TextStyle eventCardTitleTextStyle = TextStyle(
    fontSize: 20.0, color: Color(0xFF393939), fontWeight: FontWeight.w700);
const TextStyle eventCardDetailsTextStyle =
    TextStyle(fontSize: 15.0, color: Colors.black54);
const timelineTileDayTextStyle =
    TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0);
const timelineTileMonthTextStyle =
    TextStyle(fontWeight: FontWeight.w300, fontSize: 10.0);
const timelineTileIndicatorStyle = IndicatorStyle(
    padding: EdgeInsets.all(5),
    width: 10,
    indicatorXY: 0.0,
    color: Colors.green);
const timelineTileBeforeLineStyle =
    LineStyle(thickness: 1.0, color: Color(0XFFe1e1e1));
const upcomingJourneysTextStyle = TextStyle(
    fontSize: 30.0, color: Color(0xFF393939), fontWeight: FontWeight.w700);
const scheduleScreenCalendarStyle = CalendarStyle(
  todayDecoration:
      BoxDecoration(color: Color(0x4D99D2A9), shape: BoxShape.circle),
  selectedDecoration:
      BoxDecoration(color: Color(0xFF99D2A9), shape: BoxShape.circle),
  markerDecoration:
      BoxDecoration(color: Color(0XFFFBAB4B), shape: BoxShape.circle),
  // markerSize: 5,
  markersMaxCount: 1,
);

// Styling for favourites and past journeys sidebar
const TextStyle sidebarTextStyle = TextStyle(
    fontSize: 20.0,
    color: (Color(0xFF99D2A9)),
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic);

// Styling for weather
const TextStyle weatherTextStyle = TextStyle(
    fontSize: 25.0,
    color: (Color(0xFF99D2A9)),
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic);
