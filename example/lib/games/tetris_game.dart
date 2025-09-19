import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  State<TetrisGame> createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  
  List<List<int>> board = [];
  List<List<int>> currentPiece = [];
  int currentX = 0;
  int currentY = 0;
  int score = 0;
  int level = 1;
  int lines = 0;
  bool gameOver = false;
  bool gamePaused = false;
  Timer? gameTimer;
  
  // les diffférentes pièces tetris
  final List<List<List<int>>> tetrominoes = [
    // pièce I
    [[1, 1, 1, 1]],
    //pièce O
    [[1, 1], [1, 1]],
    //pièce T
    [[0, 1, 0], [1, 1, 1]],
    //pièce S
    [[0, 1, 1], [1, 1, 0]],
    //pièce Z
    [[1, 1, 0], [0, 1, 1]],
    //pièce J
    [[1, 0, 0], [1, 1, 1]],
    //pièce L
    [[0, 0, 1], [1, 1, 1]],
  ];

// liste des couleurs du jeu
  final List<Color> colors = [
    Colors.transparent,
    CupertinoColors.systemCyan,
    CupertinoColors.systemYellow,
    CupertinoColors.systemPurple,
    CupertinoColors.systemGreen,
    CupertinoColors.systemRed,
    CupertinoColors.systemBlue,
    CupertinoColors.systemOrange,
  ];

  @override
  void initState() {
    super.initState();
    initializeBoard();
    spawnNewPiece();
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void initializeBoard() {
    board = List.generate(boardHeight, (i) => List.generate(boardWidth, (j) => 0));
  }

  void spawnNewPiece() {
    final random = Random();
    final pieceIndex = random.nextInt(tetrominoes.length);
    currentPiece = tetrominoes[pieceIndex].map((row) => 
      row.map((cell) => cell == 1 ? pieceIndex + 1 : 0).toList()).toList();
    
    currentX = boardWidth ~/ 2 - currentPiece[0].length ~/ 2;
    currentY = 0;
    
    if (isCollision(currentX, currentY, currentPiece)) {
      setState(() {
        gameOver = true;
      });
      gameTimer?.cancel();
    }
  }

  bool isCollision(int x, int y, List<List<int>> piece) {
    for (int py = 0; py < piece.length; py++) {
      for (int px = 0; px < piece[py].length; px++) {
        if (piece[py][px] != 0) {
          int newX = x + px;
          int newY = y + py;
          
          if (newX < 0 || newX >= boardWidth || newY >= boardHeight) {
            return true;
          }
          
          if (newY >= 0 && board[newY][newX] != 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void placePiece() {
    for (int py = 0; py < currentPiece.length; py++) {
      for (int px = 0; px < currentPiece[py].length; px++) {
        if (currentPiece[py][px] != 0) {
          int newX = currentX + px;
          int newY = currentY + py;
          
          if (newY >= 0) {
            board[newY][newX] = currentPiece[py][px];
          }
        }
      }
    }
    
    clearLines();
    spawnNewPiece();
  }

  void clearLines() {
    int linesCleared = 0;
    
    for (int y = boardHeight - 1; y >= 0; y--) {
      bool fullLine = true;
      for (int x = 0; x < boardWidth; x++) {
        if (board[y][x] == 0) {
          fullLine = false;
          break;
        }
      }
      
      if (fullLine) {
        board.removeAt(y);
        board.insert(0, List.generate(boardWidth, (i) => 0));
        linesCleared++;
        y++; 
      }
    }
    
    if (linesCleared > 0) {
      setState(() {
        lines += linesCleared;
        score += linesCleared * 100 * level;
        level = (lines ~/ 10) + 1;
      });
    }
  }

  void startGame() {
    const baseDuration = Duration(milliseconds: 800);
    final duration = Duration(milliseconds: baseDuration.inMilliseconds ~/ level);
    
    gameTimer = Timer.periodic(duration, (timer) {
      if (!gamePaused && !gameOver) {
        moveDown();
      }
    });
  }

  void moveDown() {
    if (!isCollision(currentX, currentY + 1, currentPiece)) {
      setState(() {
        currentY++;
      });
    } else {
      placePiece();
      setState(() {});
    }
  }

  void moveLeft() {
    if (!isCollision(currentX - 1, currentY, currentPiece)) {
      setState(() {
        currentX--;
      });
    }
  }

  void moveRight() {
    if (!isCollision(currentX + 1, currentY, currentPiece)) {
      setState(() {
        currentX++;
      });
    }
  }

  List<List<int>> rotatePiece(List<List<int>> piece) {
    final rows = piece.length;
    final cols = piece[0].length;
    List<List<int>> rotated = List.generate(cols, (i) => List.generate(rows, (j) => 0));
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rotated[j][rows - 1 - i] = piece[i][j];
      }
    }
    
    return rotated;
  }

  void rotate() {
    final rotated = rotatePiece(currentPiece);
    if (!isCollision(currentX, currentY, rotated)) {
      setState(() {
        currentPiece = rotated;
      });
    }
  }

  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

  void restartGame() {
    setState(() {
      gameOver = false;
      gamePaused = false;
      score = 0;
      level = 1;
      lines = 0;
    });
    
    gameTimer?.cancel();
    initializeBoard();
    spawnNewPiece();
    startGame();
  }

  Widget buildCell(int value) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: colors[value],
        borderRadius: BorderRadius.circular(3),
        border: value != 0 ? Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ) : null,
      ),
    );
  }

  List<List<int>> getBoardWithCurrentPiece() {
    List<List<int>> displayBoard = board.map((row) => List<int>.from(row)).toList();
    
    for (int py = 0; py < currentPiece.length; py++) {
      for (int px = 0; px < currentPiece[py].length; px++) {
        if (currentPiece[py][px] != 0) {
          int newX = currentX + px;
          int newY = currentY + py;
          
          if (newX >= 0 && newX < boardWidth && newY >= 0 && newY < boardHeight) {
            displayBoard[newY][newX] = currentPiece[py][px];
          }
        }
      }
    }
    
    return displayBoard;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle:  Text('Tetris', style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),),
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
                // Statistiques
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
                          const Text('Niveau', style: TextStyle(fontSize: 12)),
                          Text('$level', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Lignes', style: TextStyle(fontSize: 12)),
                          Text('$lines', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Plateau de jeu
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: CupertinoColors.systemGrey, width: 2),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: getBoardWithCurrentPiece().map((row) => 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: row.map((cell) => buildCell(cell)).toList(),
                            ),
                          ).toList(),
                        ),
                        
                        // Overlay Game Over/Pause
                        if (gameOver || gamePaused)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withOpacity(0.8),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    gameOver ? '🎮 GAME OVER' : '⏸️ PAUSE',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (gameOver) ...[
                                    Text(
                                      'Score Final: $score',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
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
                
                // Contrôles
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Rotation et Drop
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton.filled(
                            padding: const EdgeInsets.all(15),
                            onPressed: gameOver || gamePaused ? null : rotate,
                            child: const Icon(CupertinoIcons.refresh, size: 25),
                          ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.all(15),
                            onPressed: gameOver || gamePaused ? null : () {
                              while (!isCollision(currentX, currentY + 1, currentPiece)) {
                                moveDown();
                              }
                            },
                            child: const Icon(CupertinoIcons.down_arrow, size: 25),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // mouvements du jeu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : moveLeft,
                            child: const Icon(CupertinoIcons.left_chevron, size: 25),
                          ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : moveDown,
                            child: const Icon(CupertinoIcons.chevron_down, size: 25),
                          ),
                          CupertinoButton.filled(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            onPressed: gameOver || gamePaused ? null : moveRight,
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