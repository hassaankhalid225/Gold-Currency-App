import '../domain/currency_model.dart';
import '../domain/currency_repository.dart';
import '../../../../core/data/country_data.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  @override
  Future<List<CurrencyModel>> getTopCurrencies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Existing hardcoded rates for demo
    Map<String, double> demoRates = {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'JPY': 154.20,
      'PKR': 278.50,
      'INR': 83.50,
      'AED': 3.67,
    };

    // Create a Set to avoid duplicates
    final Set<String> addedCodes = {};
    final List<CurrencyModel> currencyList = [];

    // Add demo currencies first for better UX (they have rates)
    // We need to match with country list to get Country Name/Code if possible, or hardcode
    // Actually, let's just use the demo list as base and add others.
    
    // We will iterate through allCountries to build the list
    for (var country in allCountries) {
      if (!addedCodes.contains(country.currencyCode)) {
        addedCodes.add(country.currencyCode);
        
        currencyList.add(CurrencyModel(
          code: country.currencyCode,
          name: "${country.currencyCode} (${country.name})", // Placeholder name
          rate: demoRates[country.currencyCode] ?? 1.0, // Default to 1.0 if not in demo
          countryCode: country.isoCode,
        ));
      }
    }
    
    return currencyList;
  }

  @override
  Future<double> getExchangeRate(String baseCurrency, String targetCurrency) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock logic
    // Mock logic
    
    // Convert base to USD, then USD to target
    // rate = (1 / baseInUSD) * targetInUSD ?? No.
    // Base -> USD -> Target
    // 1 Base = X USD.
    // 1 USD = Y Target.
    // 1 Base = X * Y Target.
    
    // Wait, my map is "Value of 1 Unit in USD" or "Value of 1 USD in Unit"?
    // Standard API gives "Value of 1 USD in Unit".
    // Let's redefine map as "1 USD = X Unit".
    
    Map<String, double> usdToUnit = {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'PKR': 278.50,
      'JPY': 154.20,
      'INR': 83.50,
      'AED': 3.67
    };
    
    double baseRate = usdToUnit[baseCurrency] ?? 1.0;
    double targetRate = usdToUnit[targetCurrency] ?? 1.0;
    
    // 1 Base = (1/baseRate) USD
    // (1/baseRate) USD = (1/baseRate) * targetRate Target
    
    return (1 / baseRate) * targetRate;
  }
}
