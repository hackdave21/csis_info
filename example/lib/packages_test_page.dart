import 'package:flutter/cupertino.dart';
import 'package:csis_info/csis_info.dart';

class PackagesTestPage extends StatelessWidget {
  const PackagesTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Tests des Paquets CSIS'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // section Jeux CSIS avec les plugins ajouté
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const CsisGames(
                    style: CsisGamesStyle.card,
                    showHeader: true,
                    showStats: true,
                  ),
                ),

              // jeux basiques developpés
                RetroGamesPage(),
                
                // Exemple de combinaison personnalisée
                _buildCustomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CupertinoColors.systemBlue, CupertinoColors.systemPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🚀 Package CSIS Complet',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Un package tout-en-un pour vos applications Flutter avec informations d\'entreprise et jeux intégrés.',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildFeatureChip('📱 Informations CSIS'),
              const SizedBox(width: 8),
              _buildFeatureChip('🎮 Jeux intégrés'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: CupertinoColors.white.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}