import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/authentication.dart';
import 'package:waste_app/presentation/page/login_page/login_screen.dart';
import 'package:waste_app/presentation/widgets/text_fields.dart';

class EditPassword extends StatefulWidget {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const EditPassword({
    super.key,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    currentPasswordController =
        TextEditingController(text: widget.currentPassword);
    newPasswordController = TextEditingController(text: widget.newPassword);
    confirmNewPasswordController =
        TextEditingController(text: widget.confirmNewPassword);
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Updating...');
      try {
        await Authentication().updateUserPassword(
          currentPasswordController.text,
          newPasswordController.text,
          confirmNewPasswordController.text,
        );
        await Authentication().logoutUser();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update Password Sukses'),
          ),
        );
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception:', '');
        });
      }
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ubah Password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Text('Password Lama'),
              const SizedBox(height: 10),
              WasteAppTextFields(
                hintText: 'Masukan Password Lama anda',
                controller: currentPasswordController,
                suffixIcon: true,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              const Text('Password Baru'),
              const SizedBox(height: 10),
              WasteAppTextFields(
                hintText: 'Masukan Password Baru anda',
                controller: newPasswordController,
                suffixIcon: true,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              const Text('Konfirmasi Password Baru'),
              const SizedBox(height: 10),
              WasteAppTextFields(
                hintText: 'Konfirmasi Password',
                controller: confirmNewPasswordController,
                suffixIcon: true,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 70),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7ABA78),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: _updatePassword,
                  child: const Text(
                    'Ubah Password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
