import 'package:csis_info/csis_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'csis_game_plugins_widget.dart';


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
      mainAxisSize: MainAxisSize.min, 
      children: [
        // en tête 
        _buildMainHeader(),
        
        Container(
          color: CupertinoColors.systemGrey6,
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedIndex,
            children: {
              0: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.building_2_fill, size: 16),
                    SizedBox(width: 6),
                    Text('Entreprise', style: TextStyle(fontSize: 12),),
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
          height: 800, 
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
                  showServices: false,
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
      ],
    );
  }

  Widget _buildMainHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
                      'Package csis_info',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Test complet des fonctionnalités du package',
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
              _buildHeaderStat('🎮', 'Jeux', '6 disponibles'),
              _buildHeaderStat('🛠️', 'Plugins', '4 intégrés'),
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

}