import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeNotifier with ChangeNotifier{
  ThemeData _currentTheme;
  bool _isDarkMode;

  ThemeNotifier(this._isDarkMode)
    :_currentTheme = _isDarkMode? darkmode: lightmode;

  ThemeData get currentTheme => _currentTheme;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkmode: lightmode;
    notifyListeners();
  }
}

// TO IMPLEMENT COLOUR THEME CHANGES IN THE FUTURE.