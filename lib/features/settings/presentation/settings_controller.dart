import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsController extends ChangeNotifier {
  String _defaultCountry = 'Pakistan';
  String _defaultCurrencyCode = 'PKR';

  String get defaultCountry => _defaultCountry;
  String get defaultCurrencyCode => _defaultCurrencyCode;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SettingsController() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    _defaultCountry = prefs.getString(AppConstants.defaultCountryKey) ?? 'Pakistan';
    _defaultCurrencyCode = prefs.getString(AppConstants.defaultCurrencyKey) ?? 'PKR';
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateDefaultCountry(String country) async {
    _defaultCountry = country;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.defaultCountryKey, country);
  }

  Future<void> updateDefaultCurrency(String currencyCode) async {
    _defaultCurrencyCode = currencyCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.defaultCurrencyKey, currencyCode);
  }
}
