import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waste_app/domain/customers.dart';
import 'package:waste_app/presentation/page/saving_page/methods/balance/riwayat_penarikan.dart';
import 'package:waste_app/presentation/page/saving_page/methods/balance/tarik_saldo.dart';

class CustomersBalance extends StatefulWidget {
  const CustomersBalance({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomersBalanceState createState() => _CustomersBalanceState();
}

class _CustomersBalanceState extends State<CustomersBalance> {
  List<dynamic> customers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSortCustomers();
  }

// MENGAMBIL DAN MENGURUTKAN NASABAH
  Future<void> _fetchAndSortCustomers() async {
    try {
      List<dynamic> fetchedCustomers = await Customer().getBalance();
      // MENGURUTKAN NASABAH
      fetchedCustomers.sort((a, b) => a['name'].compareTo(b['name']));
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
    final NumberFormat formatter = NumberFormat(
        '#,##0', 'id_ID'); // FORMAT RIBUAN PEMISAH INDONESIA LOCALIZATION
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 20),
            child: Text(
              'Saldo Nasabah',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text('Error: $errorMessage'))
                    : customers.isEmpty
                        ? const Center(child: Text('No nasabah found'))
                        : ListView.builder(
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              final nasabah = customers[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 15, 25, 0),
                                    child: Container(
                                      height: 65,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF6F4BD),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 15, 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              nasabah['name'],
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Rp${formatter.format(nasabah['totalBalance'])}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
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
      bottomNavigationBar: BottomAppBar(
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LiquidHistory()));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF7ABA78)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Riwayat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiquidityCustomers(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xffE66776),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Tarik Saldo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
