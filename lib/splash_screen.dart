import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waste_app/domain/authentication.dart';
import 'package:waste_app/presentation/page/login_page/login_screen.dart';
import 'package:waste_app/presentation/page/main_page/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_app/presentation/page/onboarding_page/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Authentication _authentication = Authentication();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && refreshToken != null) {
      try {
        accessToken = await _authentication.getAccessToken();
        String username = prefs.getString('username')!;
        String email = prefs.getString('email')!;

        navigateToMainPage(username, email);
      } catch (e) {
        navigateToLoginPage();
      }
    } else {
      navigateToOnboarding();
    }
  }

// JIKA TOKEN BERHASIL DIREFRESH DAN TIDAK NULL
  void navigateToMainPage(String username, String email) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainPage(username: username, email: email),
          ),
        );
      },
    );
  }

// JIKA TOKEN TIDAK BERHASIL DIREFRESH DAN TOKEN TIDAK NULL
  void navigateToLoginPage() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }

// JIKA TOKEN NULL
  void navigateToOnboarding() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/png/WasteApp.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
