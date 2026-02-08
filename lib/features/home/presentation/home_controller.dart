import 'package:flutter/material.dart';
import '../domain/home_model.dart';
import '../../currency/domain/currency_model.dart';
import '../domain/home_use_case.dart';
import '../../gold/domain/gold_use_case.dart';


enum HomeState { initial, loading, loaded, error }

class HomeController extends ChangeNotifier {
  final GetDashboardDataUseCase _getDashboardDataUseCase;
  final GetGoldPriceUseCase _getGoldPriceUseCase;

  HomeController(this._getDashboardDataUseCase, this._getGoldPriceUseCase);

  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  HomeModel? _data;
  HomeModel? get data => _data;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<String> _userSelectedCurrencyCodes = ['USD', 'PKR'];
  List<String> get userSelectedCurrencyCodes => _userSelectedCurrencyCodes;

  List<CurrencyModel> get displayedCurrencies {
     if (_data == null) return [];
     // Return currencies that are in the user's list.
     // If the user adds a currency that isn't in fetched data, we can't show it unless we fetch it.
     // For this mock/demo, we assume topCurrencies contains the pool.
     return _data!.topCurrencies.where((c) => _userSelectedCurrencyCodes.contains(c.code)).toList();
  } 

  void updateUserCurrencies(List<String> newCodes) {
    _userSelectedCurrencyCodes = List.from(newCodes);
    notifyListeners();
  }

  Future<void> loadDashboardData(String country, String currency) async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      _data = await _getDashboardDataUseCase.call(country, currency);
      _state = HomeState.loaded;
    } catch (e) {
      _state = HomeState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
