import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class GameTile {
  int value;
  bool isNew;
  bool isMerged;

  GameTile({
    this.value = 0,
    this.isNew = false,
    this.isMerged = false,
  });

  bool get isEmpty => value == 0;
  bool get isNotEmpty => value != 0;
}

class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> 
    with TickerProviderStateMixin {
  List<List<GameTile>> grid = [];
  
  int score = 0;
  int bestScore = 0;
  int moves = 0;
  int timeElapsed = 0;
  bool gameOver = false;
  bool gameWon = false;
  bool gamePaused = false;
  bool gameStarted = false;
  bool continueAfterWin = false;
  
  Timer? gameTimer;
  
  late AnimationController _moveController;
  late AnimationController _popController;
  late AnimationController _winController;
  late Animation<double> _moveAnimation;
  late Animation<double> _popAnimation;
  late Animation<double> _winAnimation;
  
  final Random random = Random();

  // Couleurs pour chaque valeur de tuile
  final Map<int, Color> tileColors = {
    2: CupertinoColors.systemGrey6,
    4: CupertinoColors.systemGrey5,
    8: CupertinoColors.systemOrange,
    16: CupertinoColors.systemRed,
    32: CupertinoColors.systemPink,
    64: CupertinoColors.systemPurple,
    128: CupertinoColors.systemIndigo,
    256: CupertinoColors.systemBlue,
    512: CupertinoColors.systemTeal,
    1024: CupertinoColors.systemGreen,
    2048: CupertinoColors.systemYellow,
  };

  final Map<int, Color> textColors = {
    2: CupertinoColors.label,
    4: CupertinoColors.label,
    8: Colors.white,
    16: Colors.white,
    32: Colors.white,
    64: Colors.white,
    128: Colors.white,
    256: Colors.white,
    512: Colors.white,
    1024: Colors.white,
    2048: Colors.black,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadBestScore();
    initializeGame();
  }

  void _setupAnimations() {
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _popController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _winController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _moveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeOut),
    );
    _popAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _popController, curve: Curves.elasticOut),
    );
    _winAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _winController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _moveController.dispose();
    _popController.dispose();
    _winController.dispose();
    super.dispose();
  }

  void _loadBestScore() {
    // En pratique, vous chargeriez cela depuis SharedPreferences
    bestScore = 0;
  }

  void _saveBestScore() {
    // En pratique, vous sauvegarderiez cela dans SharedPreferences
    if (score > bestScore) {
      bestScore = score;
    }
  }

  void initializeGame() {
    setState(() {
      grid = List.generate(4, (i) => 
        List.generate(4, (j) => GameTile()));
      score = 0;
      moves = 0;
      timeElapsed = 0;
      gameOver = false;
      gameWon = false;
      gamePaused = false;
      gameStarted = false;
      continueAfterWin = false;
    });

    // Ajouter deux tuiles initiales
    _addRandomTile();
    _addRandomTile();

    _moveController.reset();
    _popController.reset();
    _winController.reset();
  }

  void startTimer() {
    if (!gameStarted) {
      gameStarted = true;
      gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!gamePaused && !gameOver && !gameWon) {
          setState(() {
            timeElapsed++;
          });
        }
      });
    }
  }

  void _addRandomTile() {
    List<int> emptyCells = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j].isEmpty) {
          emptyCells.add(i * 4 + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = emptyCells[random.nextInt(emptyCells.length)];
      int row = randomIndex ~/ 4;
      int col = randomIndex % 4;
      
      grid[row][col].value = random.nextDouble() < 0.9 ? 2 : 4;
      grid[row][col].isNew = true;
      
      _popController.forward().then((_) {
        grid[row][col].isNew = false;
        _popController.reset();
      });
    }
  }

  bool _canMove() {
    // Vérifier s'il y a des cellules vides
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j].isEmpty) return true;
      }
    }

    // Vérifier s'il y a des fusions possibles
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        int current = grid[i][j].value;
        if ((i > 0 && grid[i-1][j].value == current) ||
            (i < 3 && grid[i+1][j].value == current) ||
            (j > 0 && grid[i][j-1].value == current) ||
            (j < 3 && grid[i][j+1].value == current)) {
          return true;
        }
      }
    }

    return false;
  }

  void _checkGameState() {
    // Vérifier la victoire (2048 atteint)
    if (!gameWon && !continueAfterWin) {
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          if (grid[i][j].value == 2048) {
            setState(() {
              gameWon = true;
            });
            _winController.forward();
            return;
          }
        }
      }
    }

    // Vérifier la défaite
    if (!_canMove()) {
      setState(() {
        gameOver = true;
      });
      _saveBestScore();
      gameTimer?.cancel();
    }
  }

  bool _moveLeft() {
    bool moved = false;
    
    for (int i = 0; i < 4; i++) {
      List<GameTile> row = grid[i].where((tile) => tile.isNotEmpty).toList();
      
      // Fusionner les tuiles adjacentes de même valeur
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j].value == row[j + 1].value && !row[j].isMerged) {
          row[j].value *= 2;
          row[j].isMerged = true;
          score += row[j].value;
          row.removeAt(j + 1);
          moved = true;
        }
      }
      
      // Remplir la ligne
      while (row.length < 4) {
        row.add(GameTile());
      }
      
      // Vérifier s'il y a eu des changements
      for (int j = 0; j < 4; j++) {
        if (grid[i][j].value != row[j].value) {
          moved = true;
        }
        grid[i][j] = row[j];
      }
    }
    
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    
    for (int i = 0; i < 4; i++) {
      List<GameTile> row = grid[i].where((tile) => tile.isNotEmpty).toList();
      
      // Fusionner les tuiles adjacentes de même valeur (de droite à gauche)
      for (int j = row.length - 1; j > 0; j--) {
        if (row[j].value == row[j - 1].value && !row[j].isMerged) {
          row[j].value *= 2;
          row[j].isMerged = true;
          score += row[j].value;
          row.removeAt(j - 1);
          moved = true;
          j--; // Ajuster l'index après suppression
        }
      }
      
      // Remplir la ligne (vides à gauche)
      while (row.length < 4) {
        row.insert(0, GameTile());
      }
      
      // Vérifier s'il y a eu des changements
      for (int j = 0; j < 4; j++) {
        if (grid[i][j].value != row[j].value) {
          moved = true;
        }
        grid[i][j] = row[j];
      }
    }
    
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    
    for (int j = 0; j < 4; j++) {
      List<GameTile> column = [];
      for (int i = 0; i < 4; i++) {
        if (grid[i][j].isNotEmpty) {
          column.add(grid[i][j]);
        }
      }
      
      // Fusionner les tuiles adjacentes de même valeur
      for (int i = 0; i < column.length - 1; i++) {
        if (column[i].value == column[i + 1].value && !column[i].isMerged) {
          column[i].value *= 2;
          column[i].isMerged = true;
          score += column[i].value;
          column.removeAt(i + 1);
          moved = true;
        }
      }
      
      // Remplir la colonne
      while (column.length < 4) {
        column.add(GameTile());
      }
      
      // Vérifier s'il y a eu des changements
      for (int i = 0; i < 4; i++) {
        if (grid[i][j].value != column[i].value) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    
    for (int j = 0; j < 4; j++) {
      List<GameTile> column = [];
      for (int i = 0; i < 4; i++) {
        if (grid[i][j].isNotEmpty) {
          column.add(grid[i][j]);
        }
      }
      
      // Fusionner les tuiles adjacentes de même valeur (de bas en haut)
      for (int i = column.length - 1; i > 0; i--) {
        if (column[i].value == column[i - 1].value && !column[i].isMerged) {
          column[i].value *= 2;
          column[i].isMerged = true;
          score += column[i].value;
          column.removeAt(i - 1);
          moved = true;
          i--; // Ajuster l'index après suppression
        }
      }
      
      // Remplir la colonne (vides en haut)
      while (column.length < 4) {
        column.insert(0, GameTile());
      }
      
      // Vérifier s'il y a eu des changements
      for (int i = 0; i < 4; i++) {
        if (grid[i][j].value != column[i].value) {
          moved = true;
        }
        grid[i][j] = column[i];
      }
    }
    
    return moved;
  }

  void _handleSwipe(String direction) {
    if (gameOver || gamePaused || (gameWon && !continueAfterWin)) return;

    startTimer();

    bool moved = false;
    
    // Réinitialiser les flags de fusion
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        grid[i][j].isMerged = false;
      }
    }

    setState(() {
      switch (direction) {
        case 'left':
          moved = _moveLeft();
          break;
        case 'right':
          moved = _moveRight();
          break;
        case 'up':
          moved = _moveUp();
          break;
        case 'down':
          moved = _moveDown();
          break;
      }

      if (moved) {
        moves++;
        _addRandomTile();
        _saveBestScore();
      }
    });

    if (moved) {
      _moveController.forward().then((_) {
        _moveController.reset();
        _checkGameState();
      });
    }
  }

  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

  void restartGame() {
    gameTimer?.cancel();
    initializeGame();
  }

  void resetStats() {
    bestScore = 0;
    restartGame();
  }

  void continueGame() {
    setState(() {
      continueAfterWin = true;
      gameWon = false;
    });
    _winController.reset();
  }

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
          middle: Text('2048', 
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
                      Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.9)!,
                      Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.95)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget('Temps', formatTime(timeElapsed), CupertinoColors.systemBlue),
                    _buildStatWidget('Coups', moves.toString(), CupertinoColors.systemOrange),
                    _buildStatWidget('Meilleur', bestScore.toString(), CupertinoColors.systemGreen),
                    _buildStatWidget('Score', score.toString(), CupertinoColors.systemYellow),
                  ],
                ),
              ),

              // Plateau de jeu
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 320,
                        height: 320,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.95)!,
                              Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.9)!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.7)!,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.9)!,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              // Gérer les gestes de balayage
                              if (details.delta.dx > 10) {
                                _handleSwipe('right');
                              } else if (details.delta.dx < -10) {
                                _handleSwipe('left');
                              } else if (details.delta.dy > 10) {
                                _handleSwipe('down');
                              } else if (details.delta.dy < -10) {
                                _handleSwipe('up');
                              }
                            },
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 16,
                              itemBuilder: (context, index) {
                                int row = index ~/ 4;
                                int col = index % 4;
                                return _buildTile(row, col);
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      // Overlay Game Over/Pause/Win
                      if (gameOver || gamePaused || gameWon)
                        Container(
                          width: 320,
                          height: 320,
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
                                      angle: gameWon ? _winAnimation.value : 0,
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
                                            color: gameWon ? CupertinoColors.systemYellow : 
                                                   gameOver ? CupertinoColors.systemRed : CupertinoColors.systemPurple,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              gameWon ? '🏆 VICTOIRE!' : 
                                              gameOver ? '💥 GAME OVER' : '⏸️ PAUSE',
                                              style: GoogleFonts.orbitron(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: gameWon ? CupertinoColors.systemYellow : 
                                                       gameOver ? CupertinoColors.systemRed : CupertinoColors.systemPurple,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            if (gameOver || gameWon) ...[
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
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: gameWon ? CupertinoColors.systemYellow : CupertinoColors.systemRed,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CupertinoButton.filled(
                                                    onPressed: restartGame,
                                                    child: const Text('Rejouer'),
                                                  ),
                                                  if (gameWon) ...[
                                                    const SizedBox(width: 16),
                                                    CupertinoButton(
                                                      onPressed: continueGame,
                                                      child: const Text('Continuer'),
                                                    ),
                                                  ],
                                                ],
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
              
              // Contrôles de mouvement
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Flèche haut
                    CupertinoButton(
                      onPressed: () => _handleSwipe('up'),
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                          ),
                        ),
                        child: const Icon(CupertinoIcons.up_arrow, color: CupertinoColors.systemBlue),
                      ),
                    ),
                    
                    // Flèches gauche et droite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoButton(
                          onPressed: () => _handleSwipe('left'),
                          child: Container(
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                              ),
                            ),
                            child: const Icon(CupertinoIcons.left_chevron, color: CupertinoColors.systemBlue),
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () => _handleSwipe('right'),
                          child: Container(
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                              ),
                            ),
                            child: const Icon(CupertinoIcons.right_chevron, color: CupertinoColors.systemBlue),
                          ),
                        ),
                      ],
                    ),
                    
                    // Flèche bas
                    CupertinoButton(
                      onPressed: () => _handleSwipe('down'),
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                          ),
                        ),
                        child: const Icon(CupertinoIcons.down_arrow, color: CupertinoColors.systemBlue),
                      ),
                    ),
                  ],
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
                    color: Color.lerp(CupertinoColors.systemYellow, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎯 Objectif: Atteignez la tuile 2048',
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Glissez ou utilisez les flèches pour déplacer les tuiles. Les tuiles de même valeur fusionnent!',
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

  Widget _buildTile(int row, int col) {
    GameTile tile = grid[row][col];
    
    return AnimatedBuilder(
      animation: Listenable.merge([_moveAnimation, _popAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: tile.isNew ? _popAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: tile.isEmpty ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(CupertinoColors.systemGrey5, Colors.white, 0.3)!,
                  CupertinoColors.systemGrey5,
                ],
              ) : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(tileColors[tile.value] ?? CupertinoColors.systemGrey, Colors.white, 0.2)!,
                  tileColors[tile.value] ?? CupertinoColors.systemGrey,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: tile.isEmpty 
                  ? CupertinoColors.systemGrey4
                  : Color.lerp(tileColors[tile.value] ?? CupertinoColors.systemGrey, Colors.transparent, 0.3)!,
                width: 1.5,
              ),
              boxShadow: tile.isEmpty ? [] : [
                BoxShadow(
                  color: Color.lerp(tileColors[tile.value] ?? CupertinoColors.systemGrey, Colors.transparent, 0.7)!,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: tile.isEmpty ? null : Text(
                tile.value.toString(),
                style: GoogleFonts.orbitron(
                  fontSize: _getFontSize(tile.value),
                  fontWeight: FontWeight.bold,
                  color: textColors[tile.value] ?? Colors.white,
                  shadows: [
                    Shadow(
                      color: Color.lerp(Colors.black, Colors.transparent, 0.8)!,
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getFontSize(int value) {
    if (value < 100) return 24;
    if (value < 1000) return 20;
    if (value < 10000) return 16;
    return 14;
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