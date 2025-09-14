import 'package:currency_converter/currenciesinfo.dart';
import 'package:currency_converter/currenciesnamefunction.dart';
import 'package:currency_converter/currenciesrate.dart';
import 'package:currency_converter/currenciesratemodel.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Getcurrenciesrate getcurrenciesrate = Getcurrenciesrate();
  Getcurrenciesname getcurrenciesname = Getcurrenciesname();

  TextEditingController amountcon = TextEditingController();

  String? selectedfrom = "PKR";
  String? selectedto = "USD";
  double? result;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return FutureBuilder<ExchangeRates>(
      future: getcurrenciesrate.currenciesrate(),
      builder: (context, ratesnapshot) {
        if (ratesnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ratesnapshot.hasError) {
          return Center(child: Text("Error: ${ratesnapshot.error}"));
        }

        if (!ratesnapshot.hasData || ratesnapshot.data!.rates.isEmpty) {
          return const Center(child: Text("No data found"));
        }

        return FutureBuilder(
          future: getcurrenciesname.fetchcurrenciesname(),
          builder: (context, namesnapshot) {
            if (namesnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (namesnapshot.hasError) {
              return Center(child: Text("Error: ${namesnapshot.error}"));
            }

            if (!namesnapshot.hasData ||
                namesnapshot.data!.currencies.isEmpty) {
              return const Center(child: Text("No data found"));
            }

            final rate = ratesnapshot.data!.rates.entries.toList();
            final name = namesnapshot.data!.currencies.entries.toList();

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Currency Converter",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                backgroundColor: Colors.white.withOpacity(0.5),
                elevation: 0,
                centerTitle: true,
              ),
              extendBodyBehindAppBar: true,

              body: Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.5),
                  image: DecorationImage(
                    image: AssetImage("lib/assets/image.png"),
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  ),
                ),

                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Select any currency to convert",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: amountcon,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Enter Amount",
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: "From",
                                      ),
                                      value: selectedfrom,
                                      items:
                                          rate
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e.key,
                                                  child: Text(
                                                    "${e.key} - ${name.firstWhere((n) => n.key == e.key).value}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedfrom = val;
                                        });
                                      },
                                    ),
                                  ),

                                  SizedBox(width: 50),

                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: "To",
                                      ),
                                      value: selectedto,
                                      items:
                                          rate
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e.key,
                                                  child: Text(
                                                    "${e.key}- ${name.firstWhere((n) => n.key == e.key).value}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedto = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedfrom != null &&
                                            selectedto != null &&
                                            amountcon.text.isNotEmpty) {
                                          double amount = double.parse(
                                            amountcon.text,
                                          );
                                          final from =
                                              rate
                                                  .firstWhere(
                                                    (e) =>
                                                        e.key == selectedfrom,
                                                  )
                                                  .value;
                                          final to =
                                              rate
                                                  .firstWhere(
                                                    (e) => e.key == selectedto,
                                                  )
                                                  .value;
                                          setState(() {
                                            result = (amount / from * to);
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.horizontal(),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Convert"),
                                          SizedBox(width: 10),

                                          Icon(Icons.navigate_next_rounded),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                              if (result != null)
                                Text(
                                  "${amountcon.text} $selectedfrom = ${double.parse(result!.toStringAsFixed(2))} $selectedto",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Currenciesinfo(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text("Check Currencies Rate"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
