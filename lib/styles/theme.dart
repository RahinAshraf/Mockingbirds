import 'package:flutter/material.dart';
import 'colors.dart';
//use custom colours later on

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = true;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get defaultTheme {
    return ThemeData(
      scaffoldBackgroundColor: CustomColors.lightModeScaffoldColour,
      appBarTheme: AppBarTheme(color: CustomColors.green),
      primarySwatch: CustomColors.lightGreen,
      backgroundColor: CustomColors.green,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CustomColors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(color: Colors.grey[900]),
      primarySwatch: CustomColors.lightGreen,
      backgroundColor: Colors.grey[900],
      textTheme: ThemeData.dark().textTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[10],
      ),
    );
  }
}
