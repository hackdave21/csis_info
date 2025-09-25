import 'package:csis_info/src/games/physics_game.dart';
import 'package:csis_info/src/retro_games_wigets/retro_games_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CsisGames extends StatefulWidget {
  /// Afficher l'en-tête CSIS
  final bool showHeader;
  
  /// Style d'affichage des jeux
  final CsisGamesStyle style;
  
  /// Nombre maximum de jeux à afficher (-1 pour tous)
  final int maxGames;
  
  /// Espacement entre les jeux
  final double gameSpacing;
  
  /// Padding du widget
  final EdgeInsetsGeometry? padding;
  
  /// Afficher les statistiques
  final bool showStats;

  const CsisGames({
    super.key,
    this.showHeader = true,
    this.style = CsisGamesStyle.card,
    this.maxGames = -1,
    this.gameSpacing = 15,
    this.padding,
    this.showStats = true,
  });

  @override
  State<CsisGames> createState() => _CsisGamesState();
}

class _CsisGamesState extends State<CsisGames> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<CsisGame> games = [
    
    CsisGame(
      name: 'Physics World',
      description: 'Monde physique avec aliens, briques et interactions réalistes',
      icon: '🚀',
      color: CupertinoColors.systemBlue,
      difficulty: 'Avancé',
      category: 'Physique',
      gameWidget: () => const PhysicsGameWidget(),
    ),
    CsisGame(
    name: 'Jeux Classiques',
    description: '5 jeux : Tetris, Snake, Tic Tac Toe, Memory, 2048',
    icon: '👾',
    color: CupertinoColors.systemBlue,
    difficulty: 'Tous niveaux',
    category: 'Arcade',
    gameWidget: () => const RetroGamesPage(),
  ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayGames = widget.maxGames > 0 
        ? games.take(widget.maxGames).toList()
        : games;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildContent(displayGames),
          ),
        );
      },
    );
  }

  Widget _buildContent(List<CsisGame> displayGames) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeader) ...[
          _buildHeader(displayGames.length),
          SizedBox(height: widget.gameSpacing + 10),
        ],
        if (widget.showStats) ...[
          SizedBox(height: widget.gameSpacing + 5),
        ],
        ...displayGames.asMap().entries.map((entry) {
          final index = entry.key;
          final game = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < displayGames.length - 1 ? widget.gameSpacing : 0,
            ),
            child: _buildGameCard(game, index),
          );
        }),
      ],
    );

    // Appliquer le padding
    if (widget.padding != null) {
      content = Padding(padding: widget.padding!, child: content);
    } else if (widget.style != CsisGamesStyle.flat) {
      content = Padding(padding: const EdgeInsets.all(16), child: content);
    }

    // Appliquer le style
    switch (widget.style) {
      case CsisGamesStyle.card:
        return Card(margin: EdgeInsets.zero, child: content);
      case CsisGamesStyle.elevated:
        return Card(margin: EdgeInsets.zero, elevation: 8, child: content);
      case CsisGamesStyle.flat:
        return content;
      case CsisGamesStyle.minimal:
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: content,
          ),
        );
    }
  }

  Widget _buildHeader(int gameCount) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CupertinoColors.systemPurple, CupertinoColors.systemBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text('🎮', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CSIS Games',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Collection de jeux rétro',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CupertinoColors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: CupertinoColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '$gameCount jeux disponibles',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildGameCard(CsisGame game, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playGame(game),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: game.color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [game.color, game.color.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: game.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(game.icon, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            game.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: game.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        game.gameWidget != null ? Icons.play_arrow : Icons.schedule,
                        color: game.color,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildGameTag(game.difficulty, CupertinoColors.systemOrange),
                    const SizedBox(width: 8),
                    _buildGameTag(game.category, CupertinoColors.systemPurple),
                    if (game.gameWidget == null) ...[
                      const SizedBox(width: 8),
                      _buildGameTag('Bientôt', CupertinoColors.systemGrey),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _playGame(CsisGame game) {
    if (game.gameWidget != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => game.gameWidget!()),
      );
    } else {
      _showComingSoon(game);
    }
  }

  void _showComingSoon(CsisGame game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🚧 ${game.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ce jeu sera bientôt disponible !'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: game.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(game.icon, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 10),
                  Text(
                    'En cours de développement...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: game.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Modèle pour un jeu CSIS
class CsisGame {
  final String name;
  final String description;
  final String icon;
  final Color color;
  final String difficulty;
  final String category;
  final Widget Function()? gameWidget;

  CsisGame({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.category,
    this.gameWidget,
  });
}

/// Styles d'affichage pour CsisGames
enum CsisGamesStyle {
  card,
  elevated,
  flat,
  minimal,
}