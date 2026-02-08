
import 'package:flutter/material.dart';
import '../../../../core/data/country_data.dart';
import '../domain/silver_model.dart';
import '../domain/silver_use_case.dart';

enum SilverState { initial, loading, loaded, error }

class SilverController extends ChangeNotifier {
  final GetSilverPriceUseCase _useCase;

  SilverController(this._useCase);

  SilverState _state = SilverState.initial;
  SilverState get state => _state;

  SilverModel? _data;
  SilverModel? get data => _data;

  String _selectedCountry = 'Pakistan';
  String get selectedCountry => _selectedCountry;

  // Use the full list from country_data.dart
  List<Country> get countryList => allCountries;

  // For Dropdown display
  List<String> get countries => allCountries.map((c) => c.name).toList();

  String _selectedCurrency = 'PKR';
  String get selectedCurrency => _selectedCurrency;

  // List of all available currencies from our country data
  List<String> get currencies => allCountries.map((c) => c.currencyCode).toSet().toList();

  void init({String? country, String? currency}) {
    if (country != null) {
      _selectedCountry = country;
      // Also update currency if not provided explicitly, or just keep default
      final countryObj = allCountries.firstWhere((c) => c.name == country, orElse: () => allCountries.first);
      if (currency == null) {
        _selectedCurrency = countryObj.currencyCode;
      }
    }
    if (currency != null) _selectedCurrency = currency;
    
    fetchSilverPrice(_selectedCountry);
  }

  void changeCountry(String country) {
    _selectedCountry = country;
    // When country changes, update currency to that country's currency by default
    final countryObj = allCountries.firstWhere((c) => c.name == country, orElse: () => allCountries.first);
    _selectedCurrency = countryObj.currencyCode;
    
    fetchSilverPrice(country);
  }

  void changeCurrency(String currency) {
    _selectedCurrency = currency;
    fetchSilverPrice(_selectedCountry);
  }

  Future<void> fetchSilverPrice(String country) async {
    _state = SilverState.loading;
    notifyListeners();

    try {
      _data = await _useCase.call(country, _selectedCurrency);
      _state = SilverState.loaded;
    } catch (e) {
      _state = SilverState.error;
    }
    notifyListeners();
  }
}
