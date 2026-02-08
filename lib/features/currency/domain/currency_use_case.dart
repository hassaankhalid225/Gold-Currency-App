import '../domain/currency_model.dart';
import '../domain/currency_repository.dart';

class CurrencyUseCase {
  final CurrencyRepository repository;

  CurrencyUseCase(this.repository);

  Future<List<CurrencyModel>> getSupportedCurrencies() {
    return repository.getTopCurrencies();
  }

  Future<double> getExchangeRate(String base, String target) {
    return repository.getExchangeRate(base, target);
  }
}
