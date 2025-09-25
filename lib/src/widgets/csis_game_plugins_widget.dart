import 'package:csis_info/src/models/csis_game_plugins_style.dart';
import 'package:csis_info/src/models/game_plugin.dart';
import 'package:csis_info/src/widgets/demos/bonfire_demo.dart';
import 'package:csis_info/src/widgets/demos/flame_engine_demo.dart';
import 'package:csis_info/src/widgets/demos/games_services_demo.dart';
import 'package:csis_info/src/widgets/demos/joystick_demo.dart';
import 'package:csis_info/src/widgets/plugin_grid.dart';
import 'package:csis_info/src/widgets/plugin_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CsisGamePlugins extends StatefulWidget {
  final CsisGamePluginsStyle style;
  final int maxPlugins;
  final bool showHeader;

  const CsisGamePlugins({
    super.key,
    this.style = CsisGamePluginsStyle.card,
    this.maxPlugins = -1,
    this.showHeader = true,
  });

  @override
  State<CsisGamePlugins> createState() => _CsisGamePluginsState();
}

class _CsisGamePluginsState extends State<CsisGamePlugins> {
  int _currentTab = 0;

  final List<GamePlugin> plugins = [
    GamePlugin(
      name: 'Flame Engine',
      description: 'Moteur de jeu 2D pour Flutter avec physique et animations',
      icon: '🔥',
      color: Colors.orange,
      category: 'Moteur',
      demoWidget: () => const FlameEngineDemo(),
    ),
    GamePlugin(
      name: 'Flutter Joystick',
      description: 'Contrôles tactiles de joystick pour jeux mobiles',
      icon: '🕹️',
      color: Colors.blue,
      category: 'Contrôles',
      demoWidget: () => const JoystickDemo(),
    ),
    GamePlugin(
      name: 'Bonfire RPG',
      description: 'Framework pour jeux RPG 2D avec tilemap',
      icon: '🏰',
      color: Colors.green,
      category: 'Moteur',
      demoWidget: () => const BonfireDemo(),
    ),
    GamePlugin(
      name: 'Games Services',
      description: 'Intégration avec Google Play Games et Game Center',
      icon: '🏆',
      color: Colors.amber,
      category: 'Services',
      demoWidget: () => const GamesServicesDemo(),
    ),
  ];

  List<GamePlugin> _getPluginsByCategory(String category) {
    return plugins.where((plugin) => plugin.category.contains(category)).toList();
  }

  void _openPluginDemo(GamePlugin plugin) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => plugin.demoWidget()),
    );
  }

  Widget _applyStyle(Widget content) {
    switch (widget.style) {
      case CsisGamePluginsStyle.card:
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: content),
        );
      case CsisGamePluginsStyle.elevated:
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: content),
        );
      case CsisGamePluginsStyle.flat:
        return Padding(padding: const EdgeInsets.all(16), child: content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPlugins = widget.maxPlugins > 0 
        ? plugins.take(widget.maxPlugins).toList()
        : plugins;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        if (widget.showHeader) ...[
          PluginHeader(pluginsCount: plugins.length),
          const SizedBox(height: 20),
        ],
        
        // Onglets des catégories avec style Cupertino
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.extraLightBackgroundGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: 50,
            child: CupertinoTabBar(
              currentIndex: _currentTab,
              onTap: (index) => setState(() => _currentTab = index),
              backgroundColor: Colors.transparent,
              activeColor: Color(0xFF1C75B8),
              inactiveColor: CupertinoColors.systemGrey,
              border: null,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.game_controller),
                  label: 'Moteurs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.rectangle_grid_2x2),
                  label: 'Contrôles',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cloud),
                  label: 'Services',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Contenu des onglets - Utiliser Flexible au lieu d'Expanded
        Flexible(
          child: IndexedStack(
            index: _currentTab,
            children: [
              SizedBox(
                height: 400, 
                child: PluginGrid(
                  plugins: _getPluginsByCategory('Moteur'),
                  onPluginTap: _openPluginDemo,
                ),
              ),
              SizedBox(
                height: 400, 
                child: PluginGrid(
                  plugins: _getPluginsByCategory('Contrôles'),
                  onPluginTap: _openPluginDemo,
                ),
              ),
              SizedBox(
                height: 400, 
                child: PluginGrid(
                  plugins: _getPluginsByCategory('Services'),
                  onPluginTap: _openPluginDemo,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return _applyStyle(content);
  }
}