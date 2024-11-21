import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/waste.dart';
import 'package:waste_app/presentation/page/saving_page/result/new_waste_success.dart';
import 'package:waste_app/presentation/widgets/text_fields.dart';
import 'package:waste_app/presentation/widgets/text_fields_customers.dart';

// ignore: must_be_immutable
class AddWaste extends StatefulWidget {
  const AddWaste({super.key});

  @override
  State<AddWaste> createState() => _AddWasteState();
}

class _AddWasteState extends State<AddWaste> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController wasteTypeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? _errorMessage;

  final Waste _waste = Waste();

// MENAMBAHKAN JENIS SAMPAH
  Future<void> _newWaste() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        final response = await _waste.newWaste(
          wasteTypeController.text,
          priceController.text,
        );
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
                'Tambah\nJenis Sampah',
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
              WasteAppTextFields(
                hintText: 'Tulis Nama Jenis Sampah',
                controller: wasteTypeController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Harga @100gram (ons)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: 'Isi Harga disini',
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
                        onPressed: () {
                          _newWaste();
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
                          'Tambah',
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
