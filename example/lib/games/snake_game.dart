import 'package:example/app_theme.dart';
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

  Widget buildCell(int x, int y) {
    bool isSnakeHead = snake.isNotEmpty && snake.first.x == x && snake.first.y == y;
    bool isSnakeBody = snake.skip(1).any((segment) => segment.x == x && segment.y == y);
    bool isFood = food.x == x && food.y == y;
    
    Color cellColor;
    Widget? cellChild;
    
    if (isSnakeHead) {
      cellColor = CupertinoColors.systemGreen;
      cellChild = const Center(
        child: Text('🐍', style: TextStyle(fontSize: 12)),
      );
    } else if (isSnakeBody) {
      cellColor = CupertinoColors.systemGreen.withOpacity(0.7);
    } else if (isFood) {
      cellColor = CupertinoColors.systemRed;
      cellChild = const Center(
        child: Text('🍎', style: TextStyle(fontSize: 12)),
      );
    } else {
      cellColor = CupertinoColors.systemGrey6;
    }
    
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(2),
        border: (isSnakeHead || isSnakeBody || isFood) ? Border.all(
          color: AppTheme.textOnPrimary.withOpacity(0.3),
          width: 1,
        ) : null,
      ),
      child: cellChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle:  Text('Jeu de serpent', style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            )),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: const Icon(CupertinoIcons.back),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: togglePause,
            child: Icon(gamePaused ? CupertinoIcons.play : CupertinoIcons.pause),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // statistiques
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Score', style: TextStyle(fontSize: 12)),
                          Text('$score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Longueur', style: TextStyle(fontSize: 12)),
                          Text('${snake.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Record', style: TextStyle(fontSize: 12)),
                          Text('$highScore', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // plateau de jeu
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: CupertinoColors.systemGrey, width: 2),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(boardSize, (y) => 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(boardSize, (x) => buildCell(x, y)),
                              ),
                            ),
                          ),
                        ),
                        
                        // overlay Game Over ou Pause
                        if (gameOver || gamePaused)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    gameOver ? '🐍 GAME OVER' : '⏸️ PAUSE',
                                    style: TextStyle(
                                      color: AppTheme.textOnPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (gameOver) ...[
                                    Text(
                                      'Score Final: $score',
                                      style:  TextStyle(
                                        color: AppTheme.textOnPrimary,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'Longueur: ${snake.length}',
                                      style:  TextStyle(
                                        color: AppTheme.textOnPrimary,
                                        fontSize: 16,
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
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // contrôles
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // flèche Haut
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        onPressed: gameOver || gamePaused ? null : () => changeDirection('up'),
                        child: const Icon(CupertinoIcons.up_arrow, size: 25),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // flèches Gauche, Bas, Droite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : () => changeDirection('left'),
                            child: const Icon(CupertinoIcons.left_chevron, size: 25),
                          ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : () => changeDirection('down'),
                            child: const Icon(CupertinoIcons.down_arrow, size: 25),
                          ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : () => changeDirection('right'),
                            child: const Icon(CupertinoIcons.right_chevron, size: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}