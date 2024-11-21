import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/waste.dart';
import 'package:waste_app/presentation/page/saving_page/result/new_waste_success.dart';
import 'package:http/http.dart' as http;
import 'package:waste_app/presentation/widgets/address_widget_textfield.dart';

class SellWaste extends StatefulWidget {
  const SellWaste({super.key});

  @override
  State<SellWaste> createState() => _SellWasteState();
}

class _SellWasteState extends State<SellWaste> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController priceController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? selectedWasteType;
  List<Map<String, String>> wasteTypes = [];
  String? _errorMessage;

  final Waste _waste = Waste();

  @override
  void initState() {
    super.initState();
    fetchWasteTypes();
  }

  Future<void> _sellWaste() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        final response = await _waste.sellWaste(selectedWasteType!,
            double.parse(priceController.text), noteController.text);
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const NewWasteSuccess(),
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception:', '');
        });
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> fetchWasteTypes() async {
    final response = await http.get(Uri.parse(
        '${dotenv.env['BASE_URL_BACKEND']}/wastetypes')); // Replace with your API URL

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        wasteTypes = data
            .map((e) => {
                  'id': e['id'] as String,
                  'name': e['name'] as String,
                })
            .toList();
        wasteTypes.sort((a, b) => a['name']!.compareTo(b['name']!));
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load waste types';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jual/Setor\nSetor Sampah',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Nama Jenis',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedWasteType,
                hint: const Text('Pilih Nama Jenis Sampah'),
                items: wasteTypes.map((Map<String, String> wasteType) {
                  return DropdownMenuItem<String>(
                    value: wasteType['id'],
                    child: Text(wasteType['name']!),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedWasteType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a waste type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Jumlah (Kg)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Isi Jumlah disini',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              const Text(
                'Catatan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AddressWidgetTextField(
                  hintText: 'Isi Catatan Jual disini',
                  controller: noteController),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 50),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () {
                          _sellWaste();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color(0xFF7ABA78),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Jual',
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
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.red, width: 2.5),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.red,
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
      ),
    );
  }
}
