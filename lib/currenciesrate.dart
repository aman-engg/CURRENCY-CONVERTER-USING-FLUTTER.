import 'package:currency_converter/currenciesratemodel.dart';
import 'package:http/http.dart' as http;

String link =
    "https://openexchangerates.org/api/latest.json?app_id=a2199ca423044566b2ec4c3406459756";

class fetchcurrnciesname {
  Future<ExchangeRates> currenciesrate() async {
    final reponse = await http.get(Uri.parse(link));
    if (reponse.statusCode == 200) {
      return exchangeRatesFromJson(reponse.body);
    } else {
      return throw Exception("faild");
    }
  }
}

class Getcurrenciesrate {
  final fetchrate = fetchcurrnciesname();
  Future<ExchangeRates> currenciesrate() async {
    final response = await fetchrate.currenciesrate();
    return response;
  }
}
