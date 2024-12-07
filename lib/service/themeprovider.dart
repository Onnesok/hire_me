import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  // Getter for ThemeMode, returns ThemeMode based on current theme
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Toggle the theme and save preference, only if the selected theme is different
  void toggleTheme(ThemeMode selectedMode) async {
    // Check if the selected theme is different from the current theme
    if ((selectedMode == ThemeMode.dark && !_isDarkMode) ||
        (selectedMode == ThemeMode.light && _isDarkMode)) {
      _isDarkMode = !_isDarkMode;  // Toggle theme
      notifyListeners();
      _saveThemePreference();
    }
  }

  // Load the saved theme preference from SharedPreferences
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to light theme
    notifyListeners();
  }

  // Save the current theme preference to SharedPreferences
  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
