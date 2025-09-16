import 'package:csis_info/csis_info.dart';
import 'package:flutter/material.dart';

class CsisTestPage extends StatelessWidget {
  const CsisTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Package CSIS'),
        backgroundColor: Colors.blue[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Test du logo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Test du Logo', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const CsisLogoWidget(width: 100, height: 100),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test des informations de base
            const CsisInfoCard(
              showLogo: true,
              showDescription: true,
              logoSize: 80,
            ),
            
            const SizedBox(height: 16),
            
            // Test des contacts
            const CsisContactWidget(
              showIcons: true,
              enableActions: true,
            ),
            
            const SizedBox(height: 16),
            
            // Test des services
            const CsisServicesList(
              maxServices: 2, // Limiter pour le test
            ),
            
            const SizedBox(height: 16),
            
            // Test des constantes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Test des Constantes', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Nom: ${CsisConstants.companyName}'),
                    Text('Services: ${CsisConstants.services.length}'),
                    Text('Contacts: ${CsisConstants.contacts.length}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}