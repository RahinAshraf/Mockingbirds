import 'package:flutter/material.dart';

class CustomColors {
  static Color green = const Color(0xFF99D2A9);
  static Color orange = const Color(0x80FF8C01);
  static Color lighterGreen = const Color(0x8099D2A9);
  static Color appBarTextColor = Colors.white;
  static Color lightModeScaffoldColour = Colors.white;
  static Color whiteReplacement =
      Color(0xFFf5f5f5); // replacement for too bright Colors.white
  static Color userMessageBubbleColor = CustomColors.green;
  static Color botMessageBubbleColor = Colors.white;

  static MaterialColor lightGreen = const MaterialColor(
    0xff99d2a9, // 0%
    <int, Color>{
      50: Color(0xffa3d7b2), //10%
      100: Color(0xffaddbba), //20%
      200: Color(0xffb8e0c3), //30%
      300: Color(0xffc2e4cb), //40%
      400: Color(0xffcce9d4), //50%
      500: Color(0xffd6eddd), //60%
      600: Color(0xffe0f2e5), //70%
      700: Color(0xffebf6ee), //80%
      800: Color(0xfff5fbf6), //90%
      900: Color(0xffffff), //100%
    },
  );
}
