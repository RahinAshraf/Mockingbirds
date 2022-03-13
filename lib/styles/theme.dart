import 'package:flutter/material.dart';

//use custom colours later on

class CustomTheme with ChangeNotifier {
  static Color appBarColor = Color(0xFF99D2A9);

  static bool _isDarkTheme = true;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    print(_isDarkTheme);
    print("here");
    notifyListeners();
  }

  static ThemeData get defaultTheme {
    return ThemeData(
      scaffoldBackgroundColor: Color(0xffffffff),
      appBarTheme: AppBarTheme(color: appBarColor),
      primarySwatch: getDefaultMaterialColor(),
      backgroundColor: Color(0xFF99D2A9),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF99D2A9),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(color: Colors.grey[900]),
      primarySwatch: getDarkMaterialColor(),
      backgroundColor: Colors.grey[900],
      textTheme: ThemeData.dark().textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static MaterialColor getDefaultMaterialColor() {
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

  static MaterialColor getDarkMaterialColor() {
    return const MaterialColor(
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
}
