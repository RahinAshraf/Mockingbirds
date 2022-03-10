import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

// General
const Color whiteReplacement =
    Color(0xFFf5f5f5); // replacement for bright white color
const Color appBarColor = Color(0xFF99D2A9); // top appbar color
const Color appBarTextColor = Colors.white;

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
        BoxDecoration(color: Color(0xFF99D2A9), shape: BoxShape.circle));
