import 'dart:convert';

class Currencies {
  final Map<String, String> currencies;

  Currencies({required this.currencies});

  factory Currencies.fromJson(Map<String, dynamic> json) {
    return Currencies(
      currencies: json.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() => currencies;
}

// Helpers
Currencies currenciesFromJson(String str) =>
    Currencies.fromJson(json.decode(str));

String currenciesToJson(Currencies data) => json.encode(data.toJson());
