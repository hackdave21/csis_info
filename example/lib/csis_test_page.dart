import 'package:csis_info/csis_info.dart';
import 'package:example/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CsisTestPage extends StatefulWidget {
  const CsisTestPage({super.key});

  @override
  State<CsisTestPage> createState() => _CsisTestPageState();
}

class _CsisTestPageState extends State<CsisTestPage> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,

      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Test du Package de CSIS',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: _isDarkMode ? Colors.white : AppTheme.textOnPrimary,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: _isDarkMode ? Colors.white : AppTheme.textOnPrimary,
          elevation: 2,
          centerTitle: true,
          actions: [
            IconButton(
              icon: _isDarkMode
                  ? Image.asset('assets/dark.png')
                  : Image.asset('assets/light.png'),
              onPressed: _toggleTheme,
              tooltip: _isDarkMode ? 'Mode clair' : 'Mode sombre',
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
             
              CsisInfo(),

               SizedBox(height: 32),

               CsisInfo(
                showLogo: false,
                showDescription: false,
                showContacts: true,
                showServices: false,
                enableContactActions: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
