import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class MemoryCard {
  final String symbol;
  final int id;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.symbol,
    required this.id,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> 
    with TickerProviderStateMixin {
  List<MemoryCard> cards = [];
  List<int> flippedCards = [];
  
  int score = 0;
  int moves = 0;
  int matches = 0;
  int bestScore = 999;
  int timeElapsed = 0;
  bool gameOver = false;
  bool gamePaused = false;
  bool gameStarted = false;
  
  Timer? gameTimer;
  Timer? flipTimer;
  
  late AnimationController _flipController;
  late AnimationController _matchController;
  late AnimationController _winController;
  late Animation<double> _flipAnimation;
  late Animation<double> _matchAnimation;
  late Animation<double> _winAnimation;
  
  final List<String> symbols = [
    '🎮', '🎯', '🎲', '🎪', '🎨', '🎭', '🎸', '🎺',
    '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏓', '🥎'
  ];
  
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    initializeGame();
  }

  void _setupAnimations() {
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _matchController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _winController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _matchAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _matchController, curve: Curves.elasticOut),
    );
    _winAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _winController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    flipTimer?.cancel();
    _flipController.dispose();
    _matchController.dispose();
    _winController.dispose();
    super.dispose();
  }

  // initialiser le jeu
  void initializeGame() {
    setState(() {
      cards.clear();
      flippedCards.clear();
      score = 0;
      moves = 0;
      matches = 0;
      timeElapsed = 0;
      gameOver = false;
      gamePaused = false;
      gameStarted = false;
    });

    // créer les paires de cartes
    List<String> gameSymbols = symbols.take(8).toList();
    List<String> cardSymbols = [...gameSymbols, ...gameSymbols];
    cardSymbols.shuffle(random);

    for (int i = 0; i < cardSymbols.length; i++) {
      cards.add(MemoryCard(
        symbol: cardSymbols[i],
        id: i,
      ));
    }

    _flipController.reset();
    _matchController.reset();
    _winController.reset();
  }

  // démarrer le timer
  void startTimer() {
    if (!gameStarted) {
      gameStarted = true;
      gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!gamePaused && !gameOver) {
          setState(() {
            timeElapsed++;
          });
        }
      });
    }
  }

  // retourner une carte
  void flipCard(int index) {
    if (gameOver || gamePaused || 
        cards[index].isFlipped || 
        cards[index].isMatched ||
        flippedCards.length >= 2) return;

    startTimer();

    setState(() {
      cards[index].isFlipped = true;
      flippedCards.add(index);
    });

    _flipController.forward().then((_) {
      _flipController.reset();
    });

    if (flippedCards.length == 2) {
      moves++;
      checkMatch();
    }
  }

  // vérifier si les cartes retournées forment une paire
  void checkMatch() {
    flipTimer = Timer(const Duration(milliseconds: 1000), () {
      int firstIndex = flippedCards[0];
      int secondIndex = flippedCards[1];

      if (cards[firstIndex].symbol == cards[secondIndex].symbol) {
        // Paire trouvée
        setState(() {
          cards[firstIndex].isMatched = true;
          cards[secondIndex].isMatched = true;
          matches++;
          score += 100 - (moves * 2); 
          if (score < 0) score = 0;
        });

        _matchController.forward().then((_) {
          _matchController.reverse();
        });

        // vérifier si le jeu est terminé
        if (matches == 8) {
          endGame();
        }
      } else {
        // pas de paire - remettre les cartes face cachée
        setState(() {
          cards[firstIndex].isFlipped = false;
          cards[secondIndex].isFlipped = false;
        });
      }

      setState(() {
        flippedCards.clear();
      });
    });
  }

  // Terminer le jeu
  void endGame() {
    setState(() {
      gameOver = true;
      if (moves < bestScore) {
        bestScore = moves;
      }
    });
    gameTimer?.cancel();
    _winController.forward();
  }

  // Pause du jeu
  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

  // Recommencer le jeu
  void restartGame() {
    gameTimer?.cancel();
    flipTimer?.cancel();
    initializeGame();
  }

  // Réinitialiser les records
  void resetStats() {
    setState(() {
      bestScore = 999;
    });
    restartGame();
  }

  // Formatage du temps
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1),
          middle: Text('Memory', 
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            )
          ),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: const Icon(CupertinoIcons.back),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: resetStats,
                child: const Icon(CupertinoIcons.refresh),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: togglePause,
                child: Icon(gamePaused ? CupertinoIcons.play_fill : CupertinoIcons.pause_fill),
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Statistiques
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.9)!,
                      Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.95)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget('Temps', formatTime(timeElapsed), CupertinoColors.systemBlue),
                    _buildStatWidget('Coups', moves.toString(), CupertinoColors.systemOrange),
                    _buildStatWidget('Record', bestScore == 999 ? '--' : bestScore.toString(), CupertinoColors.systemGreen),
                    _buildStatWidget('Paires', '$matches/8', CupertinoColors.systemPurple),
                  ],
                ),
              ),

              // Score
              if (gameStarted)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.9)!,
                        Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.95)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.7)!,
                    ),
                  ),
                  child: Text(
                    'Score: $score',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.systemBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Plateau de jeu
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 340,
                        height: 420,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.95)!,
                              Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.9)!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.7)!,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.9)!,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: cards.length,
                            itemBuilder: (context, index) {
                              return _buildCard(index);
                            },
                          ),
                        ),
                      ),
                      
                      // Overlay Game Over/Pause
                      if (gameOver || gamePaused)
                        Container(
                          width: 340,
                          height: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Color.lerp(Colors.black, Colors.transparent, 0.15),
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _winAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: gameOver ? _winAnimation.value : 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(32),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.05)!,
                                              Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1)!,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(
                                            color: gameOver ? CupertinoColors.systemGreen : CupertinoColors.systemPurple,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              gameOver ? '🎉 FÉLICITATIONS!' : '⏸️ PAUSE',
                                              style: GoogleFonts.orbitron(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: gameOver ? CupertinoColors.systemGreen : CupertinoColors.systemPurple,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            if (gameOver) ...[
                                              Text(
                                                'Temps: ${formatTime(timeElapsed)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Coups: $moves',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Score Final: $score',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: CupertinoColors.systemGreen,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              CupertinoButton.filled(
                                                onPressed: restartGame,
                                                child: const Text('Nouvelle Partie'),
                                              ),
                                            ] else ...[
                                              CupertinoButton.filled(
                                                onPressed: togglePause,
                                                child: const Text('Continuer'),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1)!,
                      Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.3)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemPurple, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '🧠 Objectif: Trouvez toutes les paires',
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Retournez 2 cartes. Si elles sont identiques, elles restent visibles!',
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    MemoryCard card = cards[index];
    bool shouldShow = card.isFlipped || card.isMatched;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_flipAnimation, _matchAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: card.isMatched ? _matchAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => flipCard(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: shouldShow ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: card.isMatched ? [
                    Color.lerp(CupertinoColors.systemGreen, Colors.white, 0.2)!,
                    CupertinoColors.systemGreen,
                  ] : [
                    Color.lerp(CupertinoColors.systemBlue, Colors.white, 0.2)!,
                    CupertinoColors.systemBlue,
                  ],
                ) : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(CupertinoColors.systemGrey, Colors.white, 0.3)!,
                    CupertinoColors.systemGrey,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: shouldShow 
                    ? (card.isMatched ? CupertinoColors.systemGreen : CupertinoColors.systemBlue)
                    : CupertinoColors.systemGrey3,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shouldShow 
                      ? Color.lerp(card.isMatched ? CupertinoColors.systemGreen : CupertinoColors.systemBlue, Colors.transparent, 0.7)!
                      : Color.lerp(Colors.black, Colors.transparent, 0.9)!,
                    blurRadius: shouldShow ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: shouldShow 
                    ? Text(
                        card.symbol,
                        key: ValueKey('symbol_${card.id}'),
                        style: TextStyle(
                          fontSize: 32,
                          shadows: [
                            Shadow(
                              color: Color.lerp(Colors.black, Colors.transparent, 0.7)!,
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: ValueKey('back_${card.id}'),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Color.lerp(CupertinoColors.systemGrey2, Colors.transparent, 0.3)!,
                              CupertinoColors.systemGrey4,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatWidget(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: CupertinoColors.secondaryLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Color.lerp(color, Colors.transparent, 0.9)!,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Color.lerp(color, Colors.transparent, 0.7)!,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}