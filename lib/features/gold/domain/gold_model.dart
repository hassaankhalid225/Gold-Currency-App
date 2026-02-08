class GoldModel {
  final double price;
  final String unit;
  final String country;
  final String currency;
  final DateTime timestamp;
  final double buyPrice;
  final double sellPrice;

  GoldModel({
    required this.price,
    required this.unit,
    required this.country,
    required this.currency,
    required this.timestamp,
    required this.buyPrice,
    required this.sellPrice,
  });

  factory GoldModel.fromJson(Map<String, dynamic> json) {
    return GoldModel(
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      country: json['country'] as String,
      currency: json['currency'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      buyPrice: (json['buy_price'] as num).toDouble(),
      sellPrice: (json['sell_price'] as num).toDouble(),
    );
  }
}
