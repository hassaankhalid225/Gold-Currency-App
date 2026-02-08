import '../../gold/domain/gold_model.dart';
import '../../currency/domain/currency_model.dart';
import '../domain/home_model.dart';
import '../domain/home_repository.dart';
import '../../../../core/data/country_data.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<HomeModel> getDashboardData(String country, String currency) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

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
      'JPY': 154.20,
      'SAR': 3.75,
      'CAD': 1.36,
      'AUD': 1.50,
      'CNY': 7.23,
    };

    List<GoldModel> goldPrices = [];
    
    final countryCurrencyMap = {
      'Pakistan': 'PKR',
      'United States': 'USD',
      'United Kingdom': 'GBP',
      'India': 'INR',
      'UAE': 'AED',
      country: currency 
    };

    countryCurrencyMap.forEach((countryName, localCurrencyCode) {
       double rate = rates[localCurrencyCode] ?? 1.0;
       double priceInLocal = basePriceUsd * rate;
       
       goldPrices.add(GoldModel(
          price: priceInLocal,
          unit: 'oz',
          country: countryName,
          currency: localCurrencyCode,
          timestamp: DateTime.now(),
          buyPrice: priceInLocal * 1.01,
          sellPrice: priceInLocal * 0.99,
       ));
    });

    // Populate ALL currencies for the "Add Currency" list
    final List<CurrencyModel> allCurrencyModels = [];
    final seenCodes = <String>{};
    
    for (var c in allCountries) {
       if (!seenCodes.contains(c.currencyCode)) {
         seenCodes.add(c.currencyCode);
         // Rate calculation: Cross rate from User Selected Currency to Target
         double rateAgainstUSD = rates[c.currencyCode] ?? 1.0;
         double userCurrencyRateAgainstUSD = rates[currency] ?? 1.0;
         
         double crossRate = (1 / userCurrencyRateAgainstUSD) * rateAgainstUSD; 
         
         allCurrencyModels.add(CurrencyModel(
           code: c.currencyCode,
           name: c.name, // Using Country Name to help identify
           rate: crossRate,
           countryCode: c.isoCode
         ));
       }
    }

    // Filter out the selected currency from the "Top" list if desired, or keep all.
    // Keeping all allows user to add any currency.
    final currencies = allCurrencyModels;

    return HomeModel(goldPrices: goldPrices, topCurrencies: currencies);
  }
}
