import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/customers.dart';
import 'package:waste_app/presentation/page/customers_page/result/new_customers_success.dart';
import 'package:waste_app/presentation/widgets/address_widget_textfield.dart';
import 'package:waste_app/presentation/widgets/text_fields.dart';
import 'package:waste_app/presentation/widgets/text_fields_customers.dart';

// ignore: must_be_immutable
class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({super.key});

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String? _errorMessage;

  final Customer _customer = Customer();

// FUNGSI REGISTRASI NASABAH
  Future<void> _registerCustomer() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        final response = await _customer.registerCustomer(
          nameController.text,
          emailController.text,
          addressController.text,
          phoneNumberController.text,
        );
        Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const NewCustomerSuccess()));
      } catch (e) {
        // ERROR MESSAGE PENGECUALIAN EXCEPTION MENJADI ""
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
                'Registrasi Nasabah',
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
              WasteAppTextFields(
                hintText: 'Tulis nama nasabah baru disini',
                controller: nameController,
                lengthLimit: true,
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
              WasteAppTextFields(
                hintText: 'Tulis nama nasabah baru disini',
                controller: emailController,
              ),
              const SizedBox(height: 30),
              const Text(
                'Alamat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AddressWidgetTextField(
                  hintText: 'Alamat Nasabah Baru',
                  controller: addressController),
              const SizedBox(height: 30),
              const Text(
                'Nomor Telepon',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WasteAppTextFieldsCustomer(
                hintText: 'format 628XXXXXXXXXX',
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
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF7ABA78)),
                  child: SizedBox(
                    width: 350,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        _registerCustomer();
                      },
                      child: const Text(
                        'Registrasi Nasabah Baru',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
