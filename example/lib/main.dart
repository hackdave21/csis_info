import 'package:csis_info/csis_info.dart';
// import 'package:csis_info/retro_games.dart';
import 'package:example/app_theme.dart';
import 'package:example/packages_test_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Jeux de CSIS ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme,
        // home: const RetroGamesPage(),
       home: const PackagesTestPage(),
    );
  }
}