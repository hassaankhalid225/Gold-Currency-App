
import 'silver_model.dart';
import 'silver_repository.dart';

class GetSilverPriceUseCase {
  final SilverRepository repository;

  GetSilverPriceUseCase(this.repository);

  Future<SilverModel> call(String country, String currency) {
    return repository.getSilverPrice(country, currency);
  }
}
