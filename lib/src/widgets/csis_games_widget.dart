import 'dart:async';
import 'dart:math';
// import 'package:flame/src/cache/assets_cache.dart';
// import 'package:flame/src/cache/images.dart';
// import 'package:flame/src/components/core/component_tree_root.dart';
// import 'package:flame/src/components/core/recycled_queue.dart';
// import 'package:flame/src/game/game_render_box.dart';
// import 'package:flame/src/game/game_widget/gesture_detector_builder.dart';
// import 'package:flame/src/game/overlay_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Text;
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart' hide Text;
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
// Use consistent Vector2 import
import 'package:vector_math/vector_math_64.dart' as vm;

/// Widget CsisGames - Collection de jeux intégrés avec packages externes réels
class CsisGames extends StatefulWidget {
  final bool showHeader;
  final CsisGamesStyle style;
  final List<String>? enabledGames;
  final double gameSpacing;
  final EdgeInsetsGeometry? padding;
  final bool showStats;
  final bool darkMode;

  const CsisGames({
    super.key,
    this.showHeader = true,
    this.style = CsisGamesStyle.card,
    this.enabledGames,
    this.gameSpacing = 15,
    this.padding,
    this.showStats = true,
    this.darkMode = false,
  });

  @override
  State<CsisGames> createState() => _CsisGamesState();
}

class _CsisGamesState extends State<CsisGames> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Configuration des jeux avec leurs packages réels
  final List<CsisGamePackage> allGames = [
    CsisGamePackage(
      id: 'flame_physics',
      name: 'CSIS Physics World',
      description: 'Un monde physique interactif avec Flame et Forge2D',
      icon: '⚽',
      color: const Color(0xFF2196F3),
      difficulty: 'Moyen',
      category: 'Physique',
      packageName: 'flame_forge2d: ^0.16.0',
      isAvailable: true,
      gameBuilder: () => const FlamePhysicsGameWrapper(),
    ),
    CsisGamePackage(
      id: 'confetti_game',
      name: 'CSIS Celebration',
      description: 'Jeu de confettis et d\'animations avec Lottie',
      icon: '🎉',
      color: const Color(0xFF9C27B0),
      difficulty: 'Facile',
      category: 'Arcade',
      packageName: 'confetti: ^0.7.0, lottie: ^2.7.0',
      isAvailable: true,
      gameBuilder: () => const ConfettiGameWrapper(),
    ),
    CsisGamePackage(
      id: 'rive_interactive',
      name: 'CSIS Rive Adventure',
      description: 'Aventure interactive avec des animations Rive',
      icon: '🎨',
      color: const Color(0xFFFF5722),
      difficulty: 'Moyen',
      category: 'Aventure',
      packageName: 'rive: ^0.12.4',
      isAvailable: true,
      gameBuilder: () => const RiveGameWrapper(),
    ),
    CsisGamePackage(
      id: 'tiled_adventure',
      name: 'CSIS Map Explorer',
      description: 'Exploration de cartes avec Tiled Maps',
      icon: '🗺️',
      color: const Color(0xFF4CAF50),
      difficulty: 'Difficile',
      category: 'Aventure',
      packageName: 'flame_tiled: ^1.17.0',
      isAvailable: true,
      gameBuilder: () => const TiledAdventureWrapper(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
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

  List<CsisGamePackage> get filteredGames {
    if (widget.enabledGames == null) return allGames;
    return allGames.where((game) => widget.enabledGames!.contains(game.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayGames = filteredGames;

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

  Widget _buildContent(List<CsisGamePackage> displayGames) {
    final theme = Theme.of(context);
    final isDark = widget.darkMode || theme.brightness == Brightness.dark;
    
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeader) ...[
          _buildHeader(displayGames.length, isDark),
          SizedBox(height: widget.gameSpacing + 10),
        ],
        if (widget.showStats) ...[
          _buildStatsCard(isDark),
          SizedBox(height: widget.gameSpacing + 5),
        ],
        ...displayGames.asMap().entries.map((entry) {
          final index = entry.key;
          final game = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < displayGames.length - 1 ? widget.gameSpacing : 0,
            ),
            child: _buildGameCard(game, index, isDark),
          );
        }),
      ],
    );

    if (widget.padding != null) {
      content = Padding(padding: widget.padding!, child: content);
    } else if (widget.style != CsisGamesStyle.flat) {
      content = Padding(padding: const EdgeInsets.all(16), child: content);
    }

    switch (widget.style) {
      case CsisGamesStyle.card:
        return Card(
          margin: EdgeInsets.zero,
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: content,
        );
      case CsisGamesStyle.elevated:
        return Card(
          margin: EdgeInsets.zero,
          elevation: 8,
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          child: content,
        );
      case CsisGamesStyle.flat:
        return content;
      case CsisGamesStyle.minimal:
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
        );
    }
  }

  Widget _buildHeader(int gameCount, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF6A1B9A), const Color(0xFF1976D2)]
            : [const Color(0xFF9C27B0), const Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.2),
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
                  color: Colors.white.withOpacity(0.2),
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Collection de jeux premium',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '$gameCount jeux disponibles',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .slideX(begin: -0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('🏆', 'Record', '12,450', isDark),
          _buildStatItem('⚡', 'Parties', '47', isDark),
          _buildStatItem('🎯', 'Favoris', '${filteredGames.length}', isDark),
        ],
      ),
    )
    .animate()
    .fadeIn(delay: 300.ms, duration: 600.ms)
    .slideY(begin: 0.3, end: 0, duration: 800.ms);
  }

  Widget _buildStatItem(String icon, String label, String value, bool isDark) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 25))
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(CsisGamePackage game, int index, bool isDark) {
    return InkWell(
      onTap: () => _playGame(game),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: game.isAvailable 
              ? game.color.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          ),
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
                      colors: game.isAvailable
                        ? [game.color, game.color.withOpacity(0.7)]
                        : [Colors.grey, Colors.grey.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (game.isAvailable ? game.color : Colors.grey).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      game.isAvailable ? game.icon : '📦',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (game.isAvailable ? game.color : Colors.grey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    game.isAvailable ? Icons.play_arrow : Icons.download,
                    color: game.isAvailable ? game.color : Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildGameTag(game.difficulty, game.color, isDark),
                const SizedBox(width: 8),
                _buildGameTag(game.category, game.color, isDark),
                const SizedBox(width: 8),
                _buildGameTag(
                  game.isAvailable ? 'Disponible' : 'Package requis',
                  game.isAvailable ? const Color(0xFF4CAF50) : Colors.orange,
                  isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: 400 + (index * 200)), duration: 600.ms)
    .slideX(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildGameTag(String text, Color color, bool isDark) {
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

  void _playGame(CsisGamePackage game) {
    if (game.isAvailable) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => game.gameBuilder()),
      );
    } else {
      _showPackageRequired(game);
    }
  }

  void _showPackageRequired(CsisGamePackage game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('📦 ${game.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ce jeu nécessite l\'installation du package :'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    game.packageName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ajoutez ce package à votre pubspec.yaml pour activer ce jeu.',
                    style: TextStyle(fontSize: 12),
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

/// Modèle pour un jeu avec package externe
class CsisGamePackage {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final String difficulty;
  final String category;
  final String packageName;
  final bool isAvailable;
  final Widget Function() gameBuilder;

  CsisGamePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.category,
    required this.packageName,
    required this.isAvailable,
    required this.gameBuilder,
  });
}

/// Styles d'affichage pour CsisGames
enum CsisGamesStyle { card, elevated, flat, minimal }

// ==================== WRAPPERS DES JEUX ====================

/// 1. JEU PHYSIQUE AVEC FLAME ET FORGE2D
class FlamePhysicsGameWrapper extends StatelessWidget {
  const FlamePhysicsGameWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSIS Physics World'),
        backgroundColor: const Color(0xFF2196F3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reset game
            },
          ),
        ],
      ),
      body: GameWidget<CsisPhysicsGame>.controlled(
        gameFactory: CsisPhysicsGame.new,
        overlayBuilderMap: {
          'GameControls': _buildPhysicsControls,
        },
        initialActiveOverlays: const ['GameControls'],
      ),
    );
  }
}

/// 2. JEU DE CONFETTIS ET ANIMATIONS
class ConfettiGameWrapper extends StatefulWidget {
  const ConfettiGameWrapper({super.key});

  @override
  State<ConfettiGameWrapper> createState() => _ConfettiGameWrapperState();
}

class _ConfettiGameWrapperState extends State<ConfettiGameWrapper> {
  late ConfettiController _confettiController;
  int score = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _startConfetti() {
    setState(() {
      score += 10;
      isPlaying = true;
    });
    _confettiController.play();
    HapticFeedback.lightImpact();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSIS Celebration'),
        backgroundColor: const Color(0xFF9C27B0),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Lottie animation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for Lottie (would show celebration animation)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Center(
                    child: Text(
                      '🎉\n🎊\n✨',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Play button
                CupertinoButton(
                  onPressed: isPlaying ? null : _startConfetti,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      isPlaying ? 'Célébration...' : 'Célébrer! 🎉',
                      style: const TextStyle(
                        color: Color(0xFF9C27B0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.pink,
                Colors.orange,
              ],
              numberOfParticles: 50,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. JEU AVEC ANIMATIONS RIVE
class RiveGameWrapper extends StatefulWidget {
  const RiveGameWrapper({super.key});

  @override
  State<RiveGameWrapper> createState() => _RiveGameWrapperState();
}

class _RiveGameWrapperState extends State<RiveGameWrapper> {
  // Controllers for Rive animations would go here
  // For now, we'll simulate with Flutter animations
  
  bool isCharacterHappy = false;
  double characterScale = 1.0;

  void _interactWithCharacter() {
    setState(() {
      isCharacterHappy = !isCharacterHappy;
      characterScale = isCharacterHappy ? 1.2 : 1.0;
    });
    
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSIS Rive Adventure'),
        backgroundColor: const Color(0xFFFF5722),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for Rive character
              GestureDetector(
                onTap: _interactWithCharacter,
                child: AnimatedScale(
                  scale: characterScale,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isCharacterHappy ? '😄\n🎨\n✨' : '😐\n🎨\n💤',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              Text(
                isCharacterHappy 
                  ? 'Le personnage CSIS est heureux!' 
                  : 'Touchez le personnage CSIS!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
              
              CupertinoButton(
                onPressed: _interactWithCharacter,
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                child: const Text(
                  'Interagir 🎨',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

/// 4. JEU D'EXPLORATION AVEC TILED MAPS
class TiledAdventureWrapper extends StatelessWidget {
  const TiledAdventureWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSIS Map Explorer'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // Show map overview
            },
          ),
        ],
      ),
      body: GameWidget<CsisTiledGame>.controlled(
        gameFactory: CsisTiledGame.new,
        overlayBuilderMap: {
          'MapControls': _buildMapControls,
          'PlayerStats': _buildPlayerStats,
        },
        initialActiveOverlays: const ['MapControls', 'PlayerStats'],
      ),
    );
  }
}

// ==================== IMPLÉMENTATIONS DES JEUX FLAME ====================

/// Jeu physique avec Forge2D
class CsisPhysicsGame extends forge2d.Forge2DGame {
  late forge2d.Body ground;
  late forge2d.Body ball;
  final List<forge2d.Body> boxes = [];

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Create world boundaries
    _createGround();
    _createWalls();
    
    // Create some physics objects
    _createBall();
    _createBoxes();
  }

  void _createGround() {
    final groundDef = forge2d.BodyDef()
      ..position = vm.Vector2(0, size.y - 50)
      ..type = forge2d.BodyType.static;
    
    ground = world.createBody(groundDef);
    
    final groundShape = forge2d.PolygonShape()
      ..setAsBox(size.x / 2, 25, vm.Vector2(size.x / 2, 0), 0);
    
    final groundFixture = forge2d.FixtureDef(groundShape)
      ..density = 1.0
      ..friction = 0.3;
    
    ground.createFixture(groundFixture);
  }

  void _createWalls() {
    // Left wall
    final leftWallDef = forge2d.BodyDef()
      ..position = vm.Vector2(-25, size.y / 2)
      ..type = forge2d.BodyType.static;
    
    final leftWall = world.createBody(leftWallDef);
    final leftWallShape = forge2d.PolygonShape()
      ..setAsBox(25, size.y / 2, vm.Vector2(25, 0), 0);
    leftWall.createFixture(forge2d.FixtureDef(leftWallShape));

    // Right wall
    final rightWallDef = forge2d.BodyDef()
      ..position = vm.Vector2(size.x + 25, size.y / 2)
      ..type = forge2d.BodyType.static;
    
    final rightWall = world.createBody(rightWallDef);
    final rightWallShape = forge2d.PolygonShape()
      ..setAsBox(25, size.y / 2, vm.Vector2(-25, 0), 0);
    rightWall.createFixture(forge2d.FixtureDef(rightWallShape));
  }

  void _createBall() {
    final ballDef = forge2d.BodyDef()
      ..position = vm.Vector2(size.x / 2, 100)
      ..type = forge2d.BodyType.dynamic;
    
    ball = world.createBody(ballDef);
    
    final ballShape = forge2d.CircleShape()..radius = 20;
    final ballFixture = forge2d.FixtureDef(ballShape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.8;
    
    ball.createFixture(ballFixture);
  }

  void _createBoxes() {
    for (int i = 0; i < 5; i++) {
      final boxDef = forge2d.BodyDef()
        ..position = vm.Vector2(50 + (i * 60.0), 200 + (i * 50.0))
        ..type = forge2d.BodyType.dynamic;
      
      final box = world.createBody(boxDef);
      
      final boxShape = forge2d.PolygonShape()
        ..setAsBox(25, 25, vm.Vector2.zero(), 0);
      final boxFixture = forge2d.FixtureDef(boxShape)
        ..density = 1.0
        ..friction = 0.3
        ..restitution = 0.5;
      
      box.createFixture(boxFixture);
      boxes.add(box);
    }
  }

  void addRandomBox() {
    final random = Random();
    final boxDef = forge2d.BodyDef()
      ..position = vm.Vector2(
        random.nextDouble() * size.x,
        random.nextDouble() * 200 + 100,
      )
      ..type = forge2d.BodyType.dynamic;
    
    final box = world.createBody(boxDef);
    
    final boxSize = 15 + random.nextDouble() * 20;
    final boxShape = forge2d.PolygonShape()
      ..setAsBox(boxSize, boxSize, vm.Vector2.zero(), 0);
    final boxFixture = forge2d.FixtureDef(boxShape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.7;
    
    box.createFixture(boxFixture);
    boxes.add(box);
  }

  void resetBall() {
    ball.setTransform(vm.Vector2(size.x / 2, 100), 0);
    ball.linearVelocity = vm.Vector2.zero();
    ball.angularVelocity = 0;
  }
}