import '../domain/gold_model.dart';
import '../domain/gold_repository.dart';

class GetGoldPriceUseCase {
  final GoldRepository repository;

  GetGoldPriceUseCase(this.repository);

  Future<GoldModel> call(String country, String currency) {
    return repository.getGoldPrice(country, currency);
  }
}
