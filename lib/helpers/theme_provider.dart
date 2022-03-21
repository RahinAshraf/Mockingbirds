import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _prefs;
  late bool _isDarkTheme;

  ThemeNotifier() {
    _isDarkTheme = false;
    _loadFromPrefs();
  }
  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  _initPrefs() async {
    SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isDarkTheme);
  }
}
