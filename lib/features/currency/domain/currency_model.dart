class CurrencyModel {
  final String code;
  final String name;
  final double rate;
  final String countryCode;

  CurrencyModel({
    required this.code,
    required this.name,
    required this.rate,
    required this.countryCode,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
      rate: (json['rate'] as num).toDouble(),
      countryCode: json['country_code'] as String,
    );
  }
}
