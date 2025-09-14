import 'dart:convert';

class ExchangeRates {
  final String disclaimer;
  final String license;
  final int timestamp;
  final String base;
  final Map<String, double> rates;

  ExchangeRates({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  factory ExchangeRates.fromJson(Map<String, dynamic> json) {
    return ExchangeRates(
      disclaimer: json["disclaimer"],
      license: json["license"],
      timestamp: json["timestamp"],
      base: json["base"],
      rates: Map<String, double>.from(
        json["rates"].map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "disclaimer": disclaimer,
    "license": license,
    "timestamp": timestamp,
    "base": base,
    "rates": rates,
  };
}

// Helpers
ExchangeRates exchangeRatesFromJson(String str) =>
    ExchangeRates.fromJson(json.decode(str));

String exchangeRatesToJson(ExchangeRates data) => json.encode(data.toJson());
