import 'currency_model.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyModel>> getTopCurrencies();
  Future<double> getExchangeRate(String baseCurrency, String targetCurrency);
}
