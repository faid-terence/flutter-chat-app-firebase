import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    notifyListeners();
  }

  set setTheme(bool isDark) {
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }
}
