import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int boardSize = 20;
  
  List<Point<int>> snake = [Point(10, 10)];
  Point<int> food = Point(5, 5);
  String direction = 'right';
  String nextDirection = 'right';
  int score = 0;
  int highScore = 0;
  bool gameOver = false;
  bool gamePaused = false;
  Timer? gameTimer;
  
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateFood();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

// debut du jeu
  void startGame() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!gamePaused && !gameOver) {
        moveSnake();
      }
    });
  }

// generer la pomme que le serpent mange
  void generateFood() {
    do {
      food = Point(random.nextInt(boardSize), random.nextInt(boardSize));
    } while (snake.contains(food));
  }

  void moveSnake() {
    direction = nextDirection;
    Point<int> head = snake.first;
    Point<int> newHead;

    switch (direction) {
      case 'up':
        newHead = Point(head.x, head.y - 1);
        break;
      case 'down':
        newHead = Point(head.x, head.y + 1);
        break;
      case 'left':
        newHead = Point(head.x - 1, head.y);
        break;
      case 'right':
        newHead = Point(head.x + 1, head.y);
        break;
      default:
        newHead = head;
    }

    // vérification les collisions avec les murs
    if (newHead.x < 0 || newHead.x >= boardSize || 
        newHead.y < 0 || newHead.y >= boardSize) {
      endGame();
      return;
    }

    // vérification les collisions avec le corps du serpent
    if (snake.contains(newHead)) {
      endGame();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      // vérification si le serpent mange la nourriture
      if (newHead == food) {
        score += 10;
        generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

// fin du jeu
  void endGame() {
    setState(() {
      gameOver = true;
      if (score > highScore) {
        highScore = score;
      }
    });
    gameTimer?.cancel();
  }

  void changeDirection(String newDirection) {
    // empêcher le serpent de faire demi-tour
    if ((direction == 'up' && newDirection == 'down') ||
        (direction == 'down' && newDirection == 'up') ||
        (direction == 'left' && newDirection == 'right') ||
        (direction == 'right' && newDirection == 'left')) {
      return;
    }
    nextDirection = newDirection;
  }

// pause 
  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

// reprendre le jeu
  void restartGame() {
    setState(() {
      snake = [Point(10, 10)];
      direction = 'right';
      nextDirection = 'right';
      score = 0;
      gameOver = false;
      gamePaused = false;
    });
    
    gameTimer?.cancel();
    generateFood();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1),
          middle: Text('Jeu de serpent', 
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
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: togglePause,
            child: Icon(gamePaused ? CupertinoIcons.play_fill : CupertinoIcons.pause_fill),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // statistiques 
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.9)!,
                      Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.95)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget('Score', score.toString(), CupertinoColors.systemGreen),
                    _buildStatWidget('Longueur', snake.length.toString(), CupertinoColors.systemBlue),
                    _buildStatWidget('Record', highScore.toString(), CupertinoColors.systemOrange),
                  ],
                ),
              ),
              
              // Plateau de jeu 
              Expanded(
                child: Column(
                  children: [
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
                                    Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.95)!,
                                    Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.9)!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.7)!,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.9)!,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(boardSize, (y) => 
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(boardSize, (x) => 
                                            Container(
                                              width: 14,
                                              height: 14,
                                              margin: const EdgeInsets.all(0.5),
                                              child: _buildGameCell(x, y, 14),
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Overlay Game Over/Pause - Couvre exactement le plateau
                            if (gameOver || gamePaused)
                              Container(
                                width: 320,
                                height: 320,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Color.lerp(Colors.black, Colors.transparent, 0.15),
                                    child: Center(
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
                                            color: gameOver ? CupertinoColors.systemRed : CupertinoColors.systemGreen,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              gameOver ? '🐍 GAME OVER' : '⏸️ PAUSE',
                                              style: GoogleFonts.orbitron(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: gameOver ? CupertinoColors.systemRed : CupertinoColors.systemGreen,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            if (gameOver) ...[
                                              Text(
                                                'Score Final: $score',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Longueur: ${snake.length}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              CupertinoButton.filled(
                                                onPressed: restartGame,
                                                child: const Text('Rejouer'),
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
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Contrôles de direction - En bas de l'écran
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
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.lerp(CupertinoColors.systemGreen, Colors.transparent, 0.7)!,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.lerp(Colors.black, Colors.transparent, 0.9)!,
                            blurRadius: 20,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Flèche Haut
                          _buildControlButton(
                            icon: CupertinoIcons.chevron_up,
                            onPressed: gameOver || gamePaused ? null : () => changeDirection('up'),
                            color: CupertinoColors.systemGreen,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Flèches Gauche, Bas, Droite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton(
                                icon: CupertinoIcons.chevron_left,
                                onPressed: gameOver || gamePaused ? null : () => changeDirection('left'),
                                color: CupertinoColors.systemBlue,
                              ),
                              _buildControlButton(
                                icon: CupertinoIcons.chevron_down,
                                onPressed: gameOver || gamePaused ? null : () => changeDirection('down'),
                                color: CupertinoColors.systemGreen,
                              ),
                              _buildControlButton(
                                icon: CupertinoIcons.chevron_right,
                                onPressed: gameOver || gamePaused ? null : () => changeDirection('right'),
                                color: CupertinoColors.systemBlue,
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildGameCell(int x, int y, double size) {
    bool isSnakeHead = snake.isNotEmpty && snake.first.x == x && snake.first.y == y;
    bool isSnakeBody = snake.skip(1).any((segment) => segment.x == x && segment.y == y);
    bool isFood = food.x == x && food.y == y;
    
    Color cellColor;
    Widget? cellChild;
    
    if (isSnakeHead) {
      cellColor = CupertinoColors.systemGreen;
      cellChild = Center(
        child: Text('🐍', style: TextStyle(fontSize: size * 0.6)),
      );
    } else if (isSnakeBody) {
      cellColor = Color.lerp(CupertinoColors.systemGreen, Colors.white, 0.3)!;
    } else if (isFood) {
      cellColor = CupertinoColors.systemRed;
      cellChild = Center(
        child: Text('🍎', style: TextStyle(fontSize: size * 0.6)),
      );
    } else {
      cellColor = Color.lerp(CupertinoColors.systemGrey6, Colors.transparent, 0.8)!;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(size * 0.1),
        border: (isSnakeHead || isSnakeBody || isFood) ? Border.all(
          color: Color.lerp(Colors.white, Colors.transparent, 0.6)!,
          width: size * 0.05,
        ) : null,
        boxShadow: (isSnakeHead || isFood) ? [
          BoxShadow(
            color: Color.lerp(cellColor, Colors.transparent, 0.6)!,
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
          ),
        ] : null,
      ),
      child: cellChild,
    );
  }

// widget pour afficher les statistiques du jeu
  Widget _buildStatWidget(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: CupertinoColors.secondaryLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color.lerp(color, Colors.transparent, 0.9)!,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color.lerp(color, Colors.transparent, 0.7)!,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

// widget pour controller les boutons du jeu
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: onPressed != null ? [
            Color.lerp(color, Colors.white, 0.2)!,
            color,
          ] : [
            CupertinoColors.systemGrey4,
            CupertinoColors.systemGrey5,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null ? [
          BoxShadow(
            color: Color.lerp(color, Colors.transparent, 0.7)!,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(12),
        onPressed: onPressed,
        child: Icon(
          icon,
        size: 24,
        color: onPressed != null ? CupertinoColors.white : CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}