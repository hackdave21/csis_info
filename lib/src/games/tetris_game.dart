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
      width: 22,
      height: 22,
      margin: const EdgeInsets.all(0.3),
      decoration: BoxDecoration(
        color: colors[value],
        borderRadius: BorderRadius.circular(2),
        border: value != 0 ? Border.all(
          color: Color.lerp(Colors.white, Colors.transparent, 0.6)!,
          width: 0.8,
        ) : null,
        boxShadow: value != 0 ? [
          BoxShadow(
            color: Color.lerp(colors[value], Colors.transparent, 0.7)!,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ] : null,
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
          backgroundColor: Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1)!,
          middle: Text('Tetris', 
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
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
              // Statistiques - plus compact
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(CupertinoColors.systemGrey6, Colors.transparent, 0.2)!,
                      Color.lerp(CupertinoColors.systemGrey6, Colors.transparent, 0.4)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemGrey4, Colors.transparent, 0.5)!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget('Score', score.toString(), CupertinoColors.systemBlue),
                    _buildStatWidget('Niveau', level.toString(), CupertinoColors.systemOrange),
                    _buildStatWidget('Lignes', lines.toString(), CupertinoColors.systemGreen),
                  ],
                ),
              ),
              
              // Plateau de jeu - utilise l'espace disponible
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 65),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CupertinoColors.black,
                            const Color(0xFF1a1a1a),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: CupertinoColors.systemGrey2,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.lerp(CupertinoColors.black, Colors.transparent, 0.7)!,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getBoardWithCurrentPiece().map((row) => 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: row.map((cell) => buildCell(cell)).toList(),
                            ),
                          ).toList(),
                        ),
                      ),
                    ),
                    
                    // Contrôles flottants semi-transparents
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
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
                            color: Color.lerp(CupertinoColors.systemGrey4, Colors.transparent, 0.5)!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.lerp(CupertinoColors.black, Colors.transparent, 0.9)!,
                              blurRadius: 20,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Rotation et Drop - plus compact
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildControlButton(
                                  icon: CupertinoIcons.arrow_clockwise,
                                  onPressed: gameOver || gamePaused ? null : rotate,
                                  color: CupertinoColors.systemPurple,
                                ),
                                _buildControlButton(
                                  icon: CupertinoIcons.arrow_down_to_line,
                                  onPressed: gameOver || gamePaused ? null : () {
                                    while (!isCollision(currentX, currentY + 1, currentPiece)) {
                                      moveDown();
                                    }
                                  },
                                  color: CupertinoColors.systemRed,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Mouvements directionnels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildControlButton(
                                  icon: CupertinoIcons.chevron_left,
                                  onPressed: gameOver || gamePaused ? null : moveLeft,
                                  color: CupertinoColors.systemBlue,
                                ),
                                _buildControlButton(
                                  icon: CupertinoIcons.chevron_down,
                                  onPressed: gameOver || gamePaused ? null : moveDown,
                                  color: CupertinoColors.systemGreen,
                                ),
                                _buildControlButton(
                                  icon: CupertinoIcons.chevron_right,
                                  onPressed: gameOver || gamePaused ? null : moveRight,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Overlay Game Over/Pause
                    if (gameOver || gamePaused)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Color.lerp(Colors.black, Colors.transparent, 0.15)!,
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
                                    color: gameOver ? CupertinoColors.systemRed : CupertinoColors.systemOrange,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      gameOver ? '🎮 GAME OVER' : '⏸️ PAUSE',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: gameOver ? CupertinoColors.systemRed : CupertinoColors.systemOrange,
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
            ],
          ),
        ),
      ),
    );
  }

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