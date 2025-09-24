import 'package:flutter/material.dart';

class BonfireDemo extends StatelessWidget {
  const BonfireDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonfire RPG Demo'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Simulation d'un monde RPG
            Container(
              height: 300,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Fond de jeu simulé
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.green.shade200, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  
                  // Éléments du jeu simulés
                  const Positioned(
                    top: 50,
                    left: 50,
                    child: Text('🏰', style: TextStyle(fontSize: 40)),
                  ),
                  const Positioned(
                    top: 100,
                    right: 80,
                    child: Text('🧙‍♂️', style: TextStyle(fontSize: 30)),
                  ),
                  const Positioned(
                    bottom: 50,
                    left: 100,
                    child: Text('⚔️', style: TextStyle(fontSize: 25)),
                  ),
                  const Positioned(
                    bottom: 80,
                    right: 50,
                    child: Text('💎', style: TextStyle(fontSize: 20)),
                  ),
                  
                  // Overlay avec titre
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'RPG World Demo',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Text(
              'Bonfire RPG Engine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Framework complet pour créer des jeux RPG 2D avec cartes, personnages et système de combat',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            
            // Fonctionnalités
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Fonctionnalités Bonfire:', 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    _buildFeatureRow('🗺️', 'Système de cartes Tiled'),
                    _buildFeatureRow('👾', 'Personnages animés'),
                    _buildFeatureRow('⚔️', 'Système de combat'),
                    _buildFeatureRow('💬', 'Dialogues et NPCs'),
                    _buildFeatureRow('🎒', 'Inventaire et objets'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
