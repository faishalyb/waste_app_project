import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/waste.dart';
import 'package:waste_app/presentation/page/saving_page/methods/waste/add_waste.dart';
import 'package:waste_app/presentation/page/saving_page/methods/waste/edit_waste.dart';

class WasteList extends StatefulWidget {
  const WasteList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WasteListState createState() => _WasteListState();
}

class _WasteListState extends State<WasteList> {
  List<dynamic> wastes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAndSortWastes();
  }

  Future<void> _fetchAndSortWastes() async {
    try {
      List<dynamic> fetchedWastes = await Waste().getWaste();
      fetchedWastes = fetchedWastes.map((waste) {
        waste['pricePer100Gram'] = waste['pricePer100Gram'];
        return waste;
      }).toList();
      fetchedWastes.sort((a, b) => a['name'].compareTo(b['name']));
      setState(() {
        wastes = fetchedWastes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _updateWasteList(Map<String, dynamic> updatedWaste) {
    setState(() {
      int index =
          wastes.indexWhere((waste) => waste['id'] == updatedWaste['id']);
      if (index != -1) {
        wastes[index] = updatedWaste;
        wastes.sort((a, b) => a['name'].compareTo(b['name']));
      }
    });
  }

  void _deleteWaste(BuildContext context, Map<String, dynamic> waste) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber,
            size: 50,
          ),
          iconColor: Colors.red,
          title: const Text(
            'PENGHAPUSAN SAMPAH',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          content: const Text(
            'Apakah anda yakin untuk menghapus sampah ini?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            SizedBox(
              width: 120,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
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
                  'Hapus Data',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 120,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.black, width: 2.5)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                child: const Text(
                  'Batal',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      EasyLoading.show(status: 'loading');
      try {
        await Waste().deleteWaste(waste['id']);
        setState(() {
          wastes.removeWhere((w) => w['id'] == waste['id']);
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sampah berhasil dihapus')),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete waste: $e')),
        );
      }
      EasyLoading.dismiss();
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
            padding: EdgeInsets.fromLTRB(25, 5, 0, 20),
            child: Text(
              'Daftar Jenis Sampah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text('Error: $errorMessage'))
                    : wastes.isEmpty
                        ? const Center(child: Text('Tidak Ada Sampah'))
                        : ListView.builder(
                            itemCount: wastes.length,
                            itemBuilder: (context, index) {
                              final sampah = wastes[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Container(
                                      height: 85,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF6F4BD),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 0, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  sampah['name'],
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                    'Rp${sampah['pricePer100Gram']}/ons')
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () async {
                                                    final updatedWaste =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditWaste(
                                                                sampah: sampah),
                                                      ),
                                                    );
                                                    if (updatedWaste != null) {
                                                      _updateWasteList(
                                                          updatedWaste);
                                                    }
                                                  },
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.green),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    _deleteWaste(
                                                        context, sampah);
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index == wastes.length - 1)
                                    const SizedBox(height: 50),
                                ],
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWaste(),
            ),
          );
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
