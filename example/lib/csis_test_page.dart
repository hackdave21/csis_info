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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // test du logo
              Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Test du Logo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      const CsisLogoWidget(width: 100, height: 100),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // test des informations 
              const CsisInfoCard(
                showLogo: true,
                showDescription: true,
                logoSize: 80,
              ),
              
              const SizedBox(height: 16),
              
              // test des contacts
              const CsisContactWidget(
                showIcons: true,
                enableActions: true,
              ),
              
              const SizedBox(height: 16),
              
              // test des services
              const CsisServicesList(
                maxServices: 2, // limiter pour le test
              ),
              
              const SizedBox(height: 16),
              
              // test des constantes
              Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test des Constantes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nom: ${CsisConstants.companyName}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Services: ${CsisConstants.services.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Contacts: ${CsisConstants.contacts.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
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