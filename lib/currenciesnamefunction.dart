import 'package:currency_converter/currenciesnamemodel.dart';
import 'package:http/http.dart' as http;

String id = "a2199ca423044566b2ec4c3406459756";
String link = "https://openexchangerates.org/api/currencies.json?app_id=$id";

class Fetchcurrenciesname {
  Future<Currencies> fetchcurrenciesname() async {
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      return currenciesFromJson(response.body);
    } else {
      throw Exception("failed to load data");
    }
  }
}

class Getcurrenciesname {
  final fetchname = Fetchcurrenciesname();
  Future<Currencies> fetchcurrenciesname() async {
    final resposne = await fetchname.fetchcurrenciesname();
    return resposne;
  }
}
