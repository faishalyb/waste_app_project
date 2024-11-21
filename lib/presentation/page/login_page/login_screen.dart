import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/domain/authentication.dart';
import 'package:waste_app/presentation/page/welcoming_page/welcoming_page.dart';
import 'package:waste_app/presentation/widgets/text_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Authentication _authentication = Authentication();
  Future<void> _login() async {
    EasyLoading.show(status: 'Loading');
    if (_formKey.currentState!.validate()) {
      try {
        // ignore: unused_local_variable
        final response = await _authentication.login(
            formKey: _formKey,
            usernameController: usernameController,
            passwordController: passwordController,
            context: context,
            setErrorMessage: (message) {
              setState(() {
                _errorMessage = message;
              });
            });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception:', '');
        });
      }
    }
    EasyLoading.dismiss();
  }

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const WelcomingPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 1000),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 150),
                  const Text(
                    "Selamat datang di WasteApp",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Masuk Akun",
                    style: TextStyle(
                        color: Color(0xFF7FB77E),
                        fontSize: 42,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 50),
                  const Text("Username"),
                  const SizedBox(height: 3),
                  WasteAppTextFields(
                    hintText: 'Masukan Username anda',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 30),
                  const Text("Password"),
                  const SizedBox(height: 3),
                  WasteAppTextFields(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    suffixIcon: true,
                  ),
                  const SizedBox(height: 10),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () async {
                      _login();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFF7FB77E)),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(const Size(
                          350, 50)), // Set your custom width and height
                    ),
                    child: const Text("Masuk",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
