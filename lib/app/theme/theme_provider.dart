import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fooddelivery_b/app/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('dark_mode_enabled') ?? false;
      notifyListeners();
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = !_isDarkMode;
      await prefs.setBool('dark_mode_enabled', _isDarkMode);
      notifyListeners();
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  Future<void> setTheme(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = isDarkMode;
      await prefs.setBool('dark_mode_enabled', _isDarkMode);
      notifyListeners();
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  ThemeData get theme => AppTheme.getApplicationTheme(isDarkMode: _isDarkMode);
} 