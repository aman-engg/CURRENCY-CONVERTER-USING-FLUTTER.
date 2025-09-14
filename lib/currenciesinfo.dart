import 'package:flutter/material.dart';
import 'package:currency_converter/currenciesrate.dart';
import 'package:currency_converter/currenciesratemodel.dart';
import 'package:currency_converter/currenciesnamefunction.dart';
import 'package:currency_converter/currenciesnamemodel.dart';

class Currenciesinfo extends StatefulWidget {
  const Currenciesinfo({super.key});

  @override
  State<Currenciesinfo> createState() => _CurrenciesinfoState();
}

class _CurrenciesinfoState extends State<Currenciesinfo> {
  final formKey = GlobalKey<FormState>();
  final Getcurrenciesrate getCurrenciesr = Getcurrenciesrate();
  final Getcurrenciesname getname = Getcurrenciesname();

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "💱 Currency Rates",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          image: DecorationImage(
            image: AssetImage("lib/assets/dollar.png"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Form(
          key: formKey,
          child: FutureBuilder<ExchangeRates>(
            future: getCurrenciesr.currenciesrate(),
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

              return FutureBuilder<Currencies>(
                future: getname.fetchcurrenciesname(),
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

                  final rates = ratesnapshot.data!;
                  final names = namesnapshot.data!;
                  final entries = names.currencies.entries.toList();

                  final filteredEntries =
                      entries.where((entry) {
                        final code = entry.key.toLowerCase();
                        final name = entry.value.toLowerCase();
                        return code.contains(searchQuery.toLowerCase()) ||
                            name.contains(searchQuery.toLowerCase());
                      }).toList();

                  return Column(
                    children: [
                      const SizedBox(height: 100),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Search currency...",
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 📋 Currency List
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredEntries.length,
                          itemBuilder: (context, index) {
                            final code = filteredEntries[index].key;
                            final name = filteredEntries[index].value;
                            final rate = rates.rates[code];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(
                                    code,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  "Rate: $rate",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
