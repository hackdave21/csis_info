
import 'package:example/csis_test_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSIS Info Package Demo',
     theme: ThemeData(
        primaryColor: const Color(0xFF1C75B8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C75B8), 
          primary: const Color(0xFF1C75B8),  
          secondary: const Color(0xFFF53C3A), 
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CsisTestPage(),
    );
  }
}