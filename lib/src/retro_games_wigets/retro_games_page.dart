import 'package:csis_info/retro_games.dart';
// import 'package:csis_info/src/games/game_2048.dart';
// import 'package:csis_info/src/games/memory_game.dart';
// import 'package:csis_info/src/games/tic_tac_toe_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetroGamesPage extends StatefulWidget {
  const RetroGamesPage({super.key});

  @override
  State<RetroGamesPage> createState() => _RetroGamesPageState();
}

class _RetroGamesPageState extends State<RetroGamesPage> with TickerProviderStateMixin {
  bool _isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<RetroGame> games = [
    RetroGame(
      name: 'Tetris',
      description: 'Le jeu de puzzle emblématique avec des formes qui tombent',
      icon: '🎮',
      color: CupertinoColors.systemBlue,
      difficulty: 'Facile',
      players: '1 Joueur',
      category: 'Puzzle',
    ),
    RetroGame(
      name: 'Jeu de serpent',
      description: 'Guidez le serpent pour manger et grandir sans vous mordre',
      icon: '🐍',
      color: CupertinoColors.systemGreen,
      difficulty: 'Moyen',
      players: '1 Joueur',
      category: 'Arcade',
    ),
//     RetroGame(
//     name: 'Tic Tac Toe',
//     description: 'Alignez 3 symboles identiques pour gagner la partie',
//     icon: '❌',
//     color: CupertinoColors.systemBlue,
//     difficulty: 'Facile',
//     players: '2 Joueurs',
//     category: 'Stratégie',
//   ),
//   RetroGame(
//     name: 'Memory',
//     description: 'Trouvez toutes les paires en retournant les cartes',
//     icon: '🧠',
//     color: CupertinoColors.systemPurple,
//     difficulty: 'Moyen',
//     players: '1 Joueur',
//     category: 'Réflexion',
//   ),
//   RetroGame(
//   name: '2048',
//   description: 'Glissez les tuiles pour atteindre 2048',
//   icon: '🎯',
//   color: CupertinoColors.systemYellow,
//   difficulty: 'Moyen',
//   players: '1 Joueur',
//   category: 'Réflexion',
// )
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _playGame(RetroGame game) {
    // naviguer vers le vrai jeu selon le nom
    switch (game.name) {
      case 'Tetris':
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const TetrisGame()),
        );
        break;
      case 'Jeu de serpent':
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const SnakeGame()),
        );
        break;
        // case 'Tic Tac Toe':
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context)=> const TicTacToeGame())
        // );
        // break;
        // case 'Memory':
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context) => const MemoryGame())
        //   );
        //   break;
        //    case '2048':
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context) => const Game2048())
        //   );
        //   break;
      default:
        GameDialogHelpers.showGameComingSoonModal(context, game);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
        scaffoldBackgroundColor: _isDarkMode 
            ? Color.lerp(CupertinoColors.black, CupertinoColors.systemGrey6, 0.3)!
            : CupertinoColors.systemGroupedBackground,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Jeux',
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _isDarkMode ? CupertinoColors.white : CupertinoColors.black,
            ),
          ),
          backgroundColor: _isDarkMode 
              ? Color.lerp(CupertinoColors.systemGrey6, Colors.transparent, 0.2)!
              : Color.lerp(CupertinoColors.white, Colors.transparent, 0.1)!,
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _toggleTheme,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: _isDarkMode ? CupertinoColors.systemYellow : CupertinoColors.systemIndigo,
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Icon(
                _isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                color: CupertinoColors.white,
                size: 18,
              ),
            ),
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  color: _isDarkMode 
                      ? Color.lerp(CupertinoColors.systemGrey6, CupertinoColors.black, 0.2)!
                      : CupertinoColors.systemGroupedBackground,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RetroGameHeader(
                                isDarkMode: _isDarkMode,
                                gamesCount: games.length,
                              ),
                              const SizedBox(height: 30),
                              StatsCard(isDarkMode: _isDarkMode),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: GameCard(
                                game: games[index],
                                index: index,
                                isDarkMode: _isDarkMode,
                                onTap: () => _playGame(games[index]),
                              ),
                            );
                          },
                          childCount: games.length,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 50),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}