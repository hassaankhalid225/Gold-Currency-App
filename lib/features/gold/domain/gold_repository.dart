import 'gold_model.dart';

abstract class GoldRepository {
  Future<GoldModel> getGoldPrice(String country, String currency);
}
