import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/customers.dart';
import 'package:waste_app/presentation/widgets/address_widget_textfield.dart';
import 'package:waste_app/presentation/widgets/text_fields_customers.dart';

class EditCustomerScreen extends StatefulWidget {
  final Map<String, dynamic> nasabah;

  const EditCustomerScreen({super.key, required this.nasabah});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  String? _errorMessage;

  final Customer _customer = Customer();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nasabah['name'] ?? '');
    addressController =
        TextEditingController(text: widget.nasabah['address'] ?? '');
    phoneNumberController =
        TextEditingController(text: widget.nasabah['phoneNumber'] ?? '');
    emailController =
        TextEditingController(text: widget.nasabah['email'] ?? '');
  }

// FUNGSI UPDATE NASABAH TERHADAP API
  Future<void> _updateCustomer() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        await _customer.updateCustomer(
          widget.nasabah['id'],
          nameController.text,
          addressController.text,
          phoneNumberController.text,
          emailController.text,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer data updated successfully')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
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
                'Edit Data Nasabah',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                hintText: 'Tulis nama nasabah disini',
                controller: nameController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: 'Tulis nama nasabah disini',
                controller: emailController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Alamat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AddressWidgetTextField(
                hintText: 'Alamat Nasabah',
                controller: addressController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Nomor Telepon',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: '08XXXXXXXXXX',
                controller: phoneNumberController,
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
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: _updateCustomer,
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
