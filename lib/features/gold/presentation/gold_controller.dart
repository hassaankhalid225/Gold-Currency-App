import 'package:flutter/material.dart';
import '../../../../core/data/country_data.dart';
import '../domain/gold_model.dart';
import '../domain/gold_use_case.dart';

enum GoldState { initial, loading, loaded, error }

class GoldController extends ChangeNotifier {
  final GetGoldPriceUseCase _useCase;

  GoldController(this._useCase);

  GoldState _state = GoldState.initial;
  GoldState get state => _state;

  GoldModel? _data;
  GoldModel? get data => _data;

  String _selectedCountry = 'Pakistan';
  String get selectedCountry => _selectedCountry;

  // Use the full list from country_data.dart
  List<Country> get countryList => allCountries;

  // For Dropdown display
  List<String> get countries => allCountries.map((c) => c.name).toList();
  
  final List<String> carats = ['24k', '22k', '21k', '18k'];

  String _selectedCarat = '24k';
  String get selectedCarat => _selectedCarat;

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
    
    fetchGoldPrice(_selectedCountry);
  }

  void changeCountry(String country) {
    _selectedCountry = country;
    // When country changes, update currency to that country's currency by default
    final countryObj = allCountries.firstWhere((c) => c.name == country, orElse: () => allCountries.first);
    _selectedCurrency = countryObj.currencyCode;
    
    fetchGoldPrice(country);
  }
  
  void changeCurrency(String currency) {
    _selectedCurrency = currency;
    fetchGoldPrice(_selectedCountry);
  }

  void changeCarat(String carat) {
    _selectedCarat = carat;
    notifyListeners();
  }

  Future<void> fetchGoldPrice(String country) async {
    _state = GoldState.loading;
    notifyListeners();

    try {
      _data = await _useCase.call(country, _selectedCurrency);
      _state = GoldState.loaded;
    } catch (e) {
      _state = GoldState.error;
    }
    notifyListeners();
  }
}
