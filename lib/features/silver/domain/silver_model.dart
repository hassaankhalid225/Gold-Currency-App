
class SilverModel {
  final double price; // Price per unit (e.g., Ounce)
  final String unit;
  final String country;
  final String currency;
  final DateTime timestamp;
  final double buyPrice;
  final double sellPrice;

  SilverModel({
    required this.price,
    required this.unit,
    required this.country,
    required this.currency,
    required this.timestamp,
    required this.buyPrice,
    required this.sellPrice,
  });
}
