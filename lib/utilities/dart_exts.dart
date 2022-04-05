import 'package:flutter/material.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/styles/colors.dart';

/// Helper extensions for [PanelWidget].
/// Author: Rahin Ashraf

/// Extension to help control navigation through app
extension BuildContextExt on BuildContext {

  ///Helper to open the place search screen
  Future<dynamic> openSearch() {
    return Navigator.of(this).push(MaterialPageRoute(
        builder: (settings) =>
            PlaceSearchScreen(LocationService(), isPop: true)));
  }

  ///Given a widget, push this widget onto the stack
  Future<R?> push<R>(Widget route) {
    return Navigator.push<R>(
      this,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }

  ///Push the given route onto the navigator, and then remove all the previous routes until the predicate returns true
  Future<R?> pushAndRemoveUntil<R>(Widget route) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => route,
        ),
        (route) => route.isCurrent);
  }

  ///Go back to the previous screen in the stack
  void pop() {
    Navigator.of(this).pop();
  }

}

///Extension to reduce length of code due to the repetitiveness of creating widgets that are commonly used
extension WidgetExts on dynamic {

  ///Creates a text widget with modified default styling
  Widget text(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 20}) {
    return Text(
      text,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  ///Creates a Floating Action Button with modified default styling
  FloatingActionButton buildFloatingActionButton(
      {Function()? onPressed, IconData iconData = Icons.add}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      elevation: 3,
      child: Icon(iconData, color: CustomColors.green),
    );
  }

  ///Creates a Circular Input Border with modified default styling
  OutlineInputBorder circularInputBorder(
      {double radius = 10.0, Color color = Colors.black, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

}
