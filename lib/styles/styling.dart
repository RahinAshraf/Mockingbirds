import 'package:flutter/material.dart';
import 'dart:math';

class CustomTheme {
  static Color appBarColor = Color(0xFF99D2A9);

  static ThemeData get defaultTheme {
    return ThemeData(
      scaffoldBackgroundColor: Color(0xffffffff),
      appBarTheme: AppBarTheme(color: appBarColor),
      primarySwatch: getMaterialColor(),
      backgroundColor: Color(0xFF99D2A9),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF99D2A9),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static MaterialColor getMaterialColor() {
    return MaterialColor(
      0xff99d2a9, // 0%
      const <int, Color>{
        50: const Color(0xffa3d7b2), //10%
        100: const Color(0xffaddbba), //20%
        200: const Color(0xffb8e0c3), //30%
        300: const Color(0xffc2e4cb), //40%
        400: const Color(0xffcce9d4), //50%
        500: const Color(0xffd6eddd), //60%
        600: const Color(0xffe0f2e5), //70%
        700: const Color(0xffebf6ee), //80%
        800: const Color(0xfff5fbf6), //90%
        900: const Color(0xffffff), //100%
      },
    );
  }
}
