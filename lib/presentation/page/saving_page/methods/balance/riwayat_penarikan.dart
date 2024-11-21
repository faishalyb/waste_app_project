import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:waste_app/domain/customers.dart';

class LiquidHistory extends StatefulWidget {
  const LiquidHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LiquidHistoryState createState() => _LiquidHistoryState();
}

class _LiquidHistoryState extends State<LiquidHistory> {
  List<dynamic> customers = [];
  Map<String, String> customerIdToName = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSortCustomer();
  }

  // MENGAMBIL DAN MENGURUTKAN NASABAH
  Future<void> _fetchAndSortCustomer() async {
    try {
      List<dynamic> fetchedCustomers = await Customer().getLiquidity();

      // MENGURUTKAN NASABAH
      fetchedCustomers.sort((b, a) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      setState(() {
        customers = fetchedCustomers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
            child: Text(
              'Riwayat Penarikan Saldo',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : customers.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Lottie.network(
                                'https://lottie.host/495775b6-a6cb-4731-8323-6d53680088c4/6q4qGAIhJV.json',
                                width: 250,
                                height: 250,
                              ),
                            ),
                            Text(
                              '$errorMessage',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          DateTime date = DateTime.parse(customer['date']);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                          String customerTypeName =
                              customer['name'] ?? 'Unknown';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 15, 25, 0),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF6F4BD),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customerTypeName,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Tanggal: $formattedDate',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Saldo Keluar: Rp${(customer['amount'].toString())}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Catatan: ${(customer['note'])}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (index == customers.length - 1)
                                const SizedBox(height: 20)
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
