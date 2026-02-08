import '../domain/gold_model.dart';
import '../domain/gold_repository.dart';

class GoldRepositoryImpl implements GoldRepository {
  @override
  Future<GoldModel> getGoldPrice(String country, String currency) async {
    // Simulate network
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock Base Price in USD per ounce
    double basePriceUsd = 2450.50;
    
    // Mock Exchange Rates against USD
    Map<String, double> rates = {
      'USD': 1.0,
      'PKR': 278.50,
      'EUR': 0.92,
      'GBP': 0.79,
      'AED': 3.67,
      'INR': 83.50,
    };
    
    double rate = rates[currency] ?? 1.0;
    double priceInTarget = basePriceUsd * rate;
    
    return GoldModel(
      price: priceInTarget,
      unit: 'oz',
      country: country,
      currency: currency, 
      timestamp: DateTime.now(),
      buyPrice: priceInTarget * 1.01,
      sellPrice: priceInTarget * 0.99,
    );
  }
}
