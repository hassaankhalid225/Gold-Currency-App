import 'package:flutter/material.dart';
import '../domain/currency_model.dart';
import '../domain/currency_use_case.dart';

enum CurrencyState { initial, loading, loaded, error }

class CurrencyController extends ChangeNotifier {
  final CurrencyUseCase _useCase;

  CurrencyController(this._useCase);

  CurrencyState _state = CurrencyState.initial;
  CurrencyState get state => _state;

  List<CurrencyModel> _currencies = [];
  List<CurrencyModel> get currencies => _currencies;

  CurrencyModel? _baseCurrency;
  CurrencyModel? get baseCurrency => _baseCurrency;

  CurrencyModel? _targetCurrency;
  CurrencyModel? get targetCurrency => _targetCurrency;

  double _currentRate = 1.0;
  double get currentRate => _currentRate;

  double _enteredAmount = 0.0;
  double get convertedAmount => _enteredAmount * _currentRate;

  Future<void> init({String? defaultCurrencyCode}) async {
    _state = CurrencyState.loading;
    notifyListeners();
    try {
      _currencies = await _useCase.getSupportedCurrencies();
      if (_currencies.isNotEmpty) {
        // Use default if provided, otherwise USD
        final baseCode = defaultCurrencyCode ?? 'USD';
        _baseCurrency = _currencies.firstWhere((c) => c.code == baseCode, orElse: () => _currencies[0]);
        // Default target to something else, e.g. USD if base is not USD, or PKR
        _targetCurrency = _currencies.firstWhere((c) => c.code == (baseCode == 'USD' ? 'PKR' : 'USD'), orElse: () => _currencies.length > 1 ? _currencies[1] : _currencies[0]);
      }
      await _fetchRate();
      _state = CurrencyState.loaded;
    } catch (e) {
      _state = CurrencyState.error;
    }
    notifyListeners();
  }

  Future<void> _fetchRate() async {
    if (_baseCurrency == null || _targetCurrency == null) return;
    try {
      _currentRate = await _useCase.getExchangeRate(_baseCurrency!.code, _targetCurrency!.code);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void setBaseCurrency(CurrencyModel? currency) {
    if (currency == null || currency == _baseCurrency) return;
    _baseCurrency = currency;
    _fetchRate();
  }

  void setTargetCurrency(CurrencyModel? currency) {
    if (currency == null || currency == _targetCurrency) return;
    _targetCurrency = currency;
    _fetchRate();
  }

  void swapCurrencies() {
    final temp = _baseCurrency;
    _baseCurrency = _targetCurrency;
    _targetCurrency = temp;
    _fetchRate();
  }

  void updateAmount(String value) {
    final val = double.tryParse(value);
    if (val != null) {
      _enteredAmount = val;
      notifyListeners();
    } else {
       if (_enteredAmount != 0.0) {
         _enteredAmount = 0.0;
         notifyListeners();
       }
    }
  }
  void setBaseCurrencyByCode(String code) {
    if (_currencies.isEmpty) return;
    try {
      final currency = _currencies.firstWhere(
        (c) => c.code == code,
        orElse: () => _currencies.first
      );
      setBaseCurrency(currency);
    } catch (_) {
      // Currency not found
    }
  }
}
