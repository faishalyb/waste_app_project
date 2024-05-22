import 'package:flutter/material.dart';
import 'package:waste_app/presentation/page/onboarding_page/onboarding_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF7FB77E)),
        fontFamily: "Poppins",
        useMaterial3: true,
      ),
      home: Onboarding_Screen(),
    );
  }
}
