import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

// Alert/Popup Dialogs
ButtonStyle popupDialogButtonStyle = ButtonStyle(
    overlayColor: MaterialStateProperty.all(Colors.green.shade200),
    backgroundColor: MaterialStateProperty.all(const Color(0XFFFBAB4B)),
    padding: MaterialStateProperty.all(
        const EdgeInsets.only(right: 10.0, left: 10.0)));

// Timeline Tile Package
const timelineTileIndicatorStyle = IndicatorStyle(
    padding: EdgeInsets.all(0),
    width: 10,
    indicatorXY: 0.5,
    drawGap: true,
    color: Color(0x80FF8C01));
const timelineTileBeforeLineStyle = const LineStyle(
  thickness: 1.5,
  color: Color(0XFFe1e1e1),
);

// Schedule Screen
const scheduleScreenCalendarStyle = CalendarStyle(
  todayDecoration:
      BoxDecoration(color: Color(0x4D99D2A9), shape: BoxShape.circle),
  selectedDecoration:
      BoxDecoration(color: Color(0xFF99D2A9), shape: BoxShape.circle),
  markerDecoration:
      BoxDecoration(color: Color(0XFFFBAB4B), shape: BoxShape.circle),
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

const TextStyle journeyLandingTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);
const TextStyle journeyTextStyle = TextStyle(
    fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, fontSize: 18);
