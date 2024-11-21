import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/waste.dart';
import 'package:waste_app/presentation/widgets/text_fields_customers.dart';

class EditWaste extends StatefulWidget {
  final Map<String, dynamic> sampah;

  const EditWaste({super.key, required this.sampah});

  @override
  State<EditWaste> createState() => _EditWasteState();
}

class _EditWasteState extends State<EditWaste> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  String? _errorMessage;

  final Waste _waste = Waste();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.sampah['name'] ?? '');
    priceController = TextEditingController(
        text: widget.sampah['pricePer100Gram']?.toString() ?? '');
  }

  Future<void> _updateWaste() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        await _waste.updateWaste(
          widget.sampah['id'],
          nameController.text,
          priceController.text,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waste Updated successfully')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, {
          'id': widget.sampah['id'],
          'name': nameController.text,
          'pricePer100Gram': priceController.text,
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception:', '');
        });
      }
    }
    EasyLoading.dismiss();
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
                'Edit\nJenis Sampah',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Nama',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: 'Edit Jenis Sampah',
                controller: nameController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Harga @100gram(ons)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: 'Alamat Nasabah',
                controller: priceController,
                textInputTypeNumber: true,
                lengthLimit: true,
              ),
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
                        onPressed: _updateWaste,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF7ABA78)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Update Data',
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
                              const BorderSide(color: Colors.red, width: 2.5)),
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
