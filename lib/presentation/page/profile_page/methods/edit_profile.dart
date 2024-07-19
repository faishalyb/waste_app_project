import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/authentication.dart';
import 'package:waste_app/presentation/page/login_page/login_screen.dart';
import 'package:waste_app/presentation/widgets/text_fields.dart';

class EditProfile extends StatefulWidget {
  final String username;
  final String email;

  const EditProfile({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Updating...');
      try {
        await Authentication().updateUserProfile(
          emailController.text,
          usernameController.text,
        );
        await Authentication().logoutUser();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update Sukses'),
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
                'Edit Profil',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              const Text('Username'),
              const SizedBox(height: 10),
              WasteAppTextFields(
                hintText: 'Username',
                controller: usernameController,
              ),
              const SizedBox(height: 30),
              const Text('Email'),
              const SizedBox(height: 10),
              WasteAppTextFields(
                hintText: 'Email',
                controller: emailController,
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 70),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0XFF7ABA78),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: _updateProfile,
                  child: const Text(
                    'Simpan',
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
