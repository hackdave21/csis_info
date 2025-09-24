import 'package:csis_info/csis_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'csis_game_plugins_widget.dart';

/// Widget de démonstration complète du package CSIS
/// 
/// Ce widget combine toutes les fonctionnalités du package :
/// - Informations de l'entreprise
/// - Jeux développés
/// - Plugins de développement de jeux
/// 
/// Exemple d'utilisation:
/// ```dart
/// CsisCompleteDemo()
/// ```
class CsisCompleteDemo extends StatefulWidget {
  const CsisCompleteDemo({super.key});

  @override
  State<CsisCompleteDemo> createState() => _CsisCompleteDemoState();
}

class _CsisCompleteDemoState extends State<CsisCompleteDemo> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Important: Changé de max à min
      children: [
        // En-tête principal
        _buildMainHeader(),
        
        // Navigation par onglets Cupertino
        Container(
          color: CupertinoColors.systemGrey6,
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedIndex,
            children: {
              0: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.building_2_fill, size: 16),
                    SizedBox(width: 6),
                    Text('Entreprise'),
                  ],
                ),
              ),
              1: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.game_controller, size: 16),
                    SizedBox(width: 6),
                    Text('Jeux'),
                  ],
                ),
              ),
              2: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.game_controller, size: 16),
                    SizedBox(width: 6),
                    Text('Plugins'),
                  ],
                ),
              ),
            },
            onValueChanged: (index) {
              setState(() {
                _selectedIndex = index ?? 0;
              });
            },
          ),
        ),
        
        // Contenu des onglets avec hauteur fixe
        SizedBox(
          height: 500, // Hauteur fixe pour éviter les contraintes non-bornées
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              // Onglet Entreprise
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: CsisInfo(
                  style: CsisInfoStyle.flat,
                  showLogo: true,
                  showDescription: true,
                  showContacts: true,
                  showServices: true,
                ),
              ),
              
              // Onglet Jeux
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: CsisGames(
                  style: CsisGamesStyle.flat,
                  showHeader: false,
                  showStats: true,
                ),
              ),
              
              // Onglet Plugins
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: CsisGamePlugins(
                  style: CsisGamePluginsStyle.flat,
                  showHeader: false,
                ),
              ),
            ],
          ),
        ),
        
        // Barre de navigation inférieure
        _buildBottomStats(),
      ],
    );
  }

  Widget _buildMainHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoTheme.of(context).primaryColor,
            CupertinoTheme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text('🏢', style: TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CSIS Package Demo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Showcase complet des fonctionnalités',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Indicateurs de contenu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat('📋', 'Infos', 'Entreprise'),
              _buildHeaderStat('🎮', 'Jeux', '4 disponibles'),
              _buildHeaderStat('🛠️', 'Plugins', '9 intégrés'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String icon, String title, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomStats() {
    final stats = [
      ('Entreprise', _selectedIndex == 0),
      ('Jeux', _selectedIndex == 1),
      ('Plugins', _selectedIndex == 2),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          final isSelected = stat.$2;
          
          return CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Text(
              stat.$1,
              style: TextStyle(
                color: isSelected 
                    ? CupertinoTheme.of(context).primaryColor
                    : CupertinoColors.systemGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}