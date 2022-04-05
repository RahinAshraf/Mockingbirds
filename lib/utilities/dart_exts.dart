import 'package:flutter/material.dart';
import 'package:veloplan/providers/location_service.dart';
import 'package:veloplan/screens/place_search_screen.dart';
import 'package:veloplan/styles/colors.dart';

/// Helper extensions for [PanelWidget].
/// Author: Rahin Ashraf
extension BuildContextExt on BuildContext {
  Future<dynamic> openSearch() {
    return Navigator.of(this).push(MaterialPageRoute(
        builder: (settings) =>
            PlaceSearchScreen(LocationService(), isPop: true)));
  }

  Future<R?> push<R>(Widget route) {
    return Navigator.push<R>(
      this,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }

  Future<R?> pushAndRemoveUntil<R>(Widget route) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => route,
        ),
        (route) => route.isCurrent);
  }

  void pop() {
    Navigator.of(this).pop();
  }
}

extension WidgetExts on dynamic {
  Widget text(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 20}) {
    return Text(
      text,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      {Function()? onPressed, IconData iconData = Icons.add}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      elevation: 3,
      child: Icon(iconData, color: CustomColors.green),
    );
  }

  OutlineInputBorder circularInputBorder(
      {double radius = 10.0, Color color = Colors.black, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
