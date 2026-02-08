import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.themeModeKey, _isDarkMode);
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(AppConstants.themeModeKey) ?? false;
    notifyListeners();
  }
}
