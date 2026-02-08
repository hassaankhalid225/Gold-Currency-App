import '../../gold/domain/gold_model.dart';
import '../../currency/domain/currency_model.dart';

class HomeModel {
  final List<GoldModel> goldPrices;
  final List<CurrencyModel> topCurrencies;

  HomeModel({
    required this.goldPrices,
    required this.topCurrencies,
  });
}
