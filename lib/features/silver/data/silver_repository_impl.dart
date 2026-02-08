
import '../domain/silver_model.dart';
import '../domain/silver_repository.dart';

class SilverRepositoryImpl implements SilverRepository {
  @override
  Future<SilverModel> getSilverPrice(String country, String currency) async {
    // Simulate network
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock Base Price in USD per ounce (Silver is much cheaper than Gold, e.g. $30)
    double basePriceUsd = 30.50;
    
    // Mock Exchange Rates against USD (Reusing same logic as Gold/Currency)
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
    
    return SilverModel(
      price: priceInTarget,
      unit: 'oz',
      country: country,
      currency: currency, 
      timestamp: DateTime.now(),
      buyPrice: priceInTarget * 1.02, // Spreads might be different
      sellPrice: priceInTarget * 0.98,
    );
  }
}
