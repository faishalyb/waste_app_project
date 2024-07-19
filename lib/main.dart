import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/splash_screen.dart';

Future<void> main() async {
  //SECURE WITH .ENV
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // ignore: avoid_print
    print("Error loading .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      title: 'WasteApp',
      theme: ThemeData(
        fontFamily: "Poppins",
        bottomAppBarTheme: const BottomAppBarTheme(
          elevation: 0,
          color: Colors.transparent, //
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, //
          scrolledUnderElevation: 0, //
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
