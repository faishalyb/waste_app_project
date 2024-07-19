import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waste_app/domain/waste.dart';

class WasteHistory extends StatefulWidget {
  const WasteHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WasteHistoryState createState() => _WasteHistoryState();
}

class _WasteHistoryState extends State<WasteHistory> {
  List<dynamic> wastes = [];
  Map<String, String> wasteIdToName = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSortWaste();
  }

  // MENGAMBIL DAN MENGURUTKAN SAMPAH
  Future<void> _fetchAndSortWaste() async {
    try {
      List<dynamic> fetchedWaste = await Waste().getSellStock();
      List<dynamic> wasteTypes = await Waste().getWaste();

      // Create a mapping from wasteTypeId to waste type name
      wasteIdToName = {for (var type in wasteTypes) type['id']: type['name']};

      // Replace wasteTypeId with the corresponding name
      for (var waste in fetchedWaste) {
        waste['wasteTypeName'] =
            wasteIdToName[waste['wasteTypeId']] ?? 'Unknown';
      }

      // MENGURUTKAN SAMPAH
      fetchedWaste.sort((b, a) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      setState(() {
        wastes = fetchedWaste;
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
              'Riwayat Jual Sampah',
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
                    : wastes.isEmpty
                        ? const Center(child: Text('No nasabah found'))
                        : ListView.builder(
                            itemCount: wastes.length,
                            itemBuilder: (context, index) {
                              final waste = wastes[index];
                              DateTime date = DateTime.parse(waste['date']);
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(date);
                              String wasteTypeName =
                                  waste['wasteTypeName'] ?? 'Unknown';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 15, 25, 0),
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
                                                wasteTypeName,
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
                                                'Jumlah Keluar: ${double.parse(waste['amount'].toString()).toStringAsFixed(1)} Kg',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                'Catatan: ${(waste['note'])}',
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
                                  if (index == wastes.length - 1)
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
