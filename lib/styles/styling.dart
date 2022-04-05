import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'colors.dart';

// Alert/Popup Dialogs
ButtonStyle popupDialogButtonStyle = ButtonStyle(
    overlayColor: MaterialStateProperty.all(Colors.green.shade200),
    backgroundColor: MaterialStateProperty.all(const Color(0XFFFBAB4B)),
    padding: MaterialStateProperty.all(
        const EdgeInsets.only(right: 10.0, left: 10.0)));

// Timeline Tile Package
IndicatorStyle timelineTileIndicatorStyle = IndicatorStyle(
    padding: EdgeInsets.all(0),
    width: 10,
    indicatorXY: 0.5,
    drawGap: true,
    color: CustomColors.orange);

const timelineTileBeforeLineStyle = const LineStyle(
  thickness: 1.5,
  color: Color(0XFFe1e1e1),
);

// Schedule Screen
CalendarStyle scheduleScreenCalendarStyle = CalendarStyle(
  todayDecoration:
      BoxDecoration(color: Color(0x4D99D2A9), shape: BoxShape.circle),
  selectedDecoration:
      BoxDecoration(color: CustomColors.green, shape: BoxShape.circle),
  markerDecoration:
      BoxDecoration(color: Color(0XFFFBAB4B), shape: BoxShape.circle),
  markersMaxCount: 1,
);
