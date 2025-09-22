import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with TickerProviderStateMixin {
  List<List<String>> board = List.generate(3, (i) => List.generate(3, (j) => ''));
  String currentPlayer = 'X';
  String winner = '';
  bool gameOver = false;
  bool gamePaused = false;
  int scoreX = 0;
  int scoreO = 0;
  int draws = 0;
  List<List<int>> winningCells = [];
  
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  // effectuer un mouvement
  void makeMove(int row, int col) {
    if (gameOver || gamePaused || board[row][col] != '') return;

    setState(() {
      board[row][col] = currentPlayer;
    });

    _scaleController.reset();
    _scaleController.forward();

    if (checkWinner()) {
      setState(() {
        winner = currentPlayer;
        gameOver = true;
        if (currentPlayer == 'X') {
          scoreX++;
        } else {
          scoreO++;
        }
      });
      _rotationController.forward();
    } else if (isBoardFull()) {
      setState(() {
        winner = 'Match nul';
        gameOver = true;
        draws++;
      });
    } else {
      setState(() {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      });
    }
  }

  // vérifier s'il y a un gagnant
  bool checkWinner() {
    // vérifier les lignes
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        winningCells = [[i, 0], [i, 1], [i, 2]];
        return true;
      }
    }

    // vérifier les colonnes
    for (int j = 0; j < 3; j++) {
      if (board[0][j] != '' &&
          board[0][j] == board[1][j] &&
          board[1][j] == board[2][j]) {
        winningCells = [[0, j], [1, j], [2, j]];
        return true;
      }
    }

    // vérifier les diagonales
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      winningCells = [[0, 0], [1, 1], [2, 2]];
      return true;
    }

    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      winningCells = [[0, 2], [1, 1], [2, 0]];
      return true;
    }

    return false;
  }

  // vérifier si le plateau est plein
  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '') return false;
      }
    }
    return true;
  }

  // pause du jeu
  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

  // recommencer une partie
  void restartGame() {
    setState(() {
      board = List.generate(3, (i) => List.generate(3, (j) => ''));
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
      gamePaused = false;
      winningCells = [];
    });
    
    _scaleController.reset();
    _rotationController.reset();
  }

  // réinitialiser tout le jeu
  void resetAll() {
    setState(() {
      board = List.generate(3, (i) => List.generate(3, (j) => ''));
      currentPlayer = 'X';
      winner = '';
      gameOver = false;
      gamePaused = false;
      winningCells = [];
      scoreX = 0;
      scoreO = 0;
      draws = 0;
    });
    
    _scaleController.reset();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Color.lerp(CupertinoColors.systemBackground, Colors.transparent, 0.1),
          middle: Text('Tic Tac Toe', 
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
                onPressed: resetAll,
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
              // statistiques
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9)!,
                      Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.95)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatWidget('X Gagne', scoreX.toString(), CupertinoColors.systemBlue),
                    _buildStatWidget('Match Nul', draws.toString(), CupertinoColors.systemOrange),
                    _buildStatWidget('O Gagne', scoreO.toString(), CupertinoColors.systemRed),
                  ],
                ),
              ),

              // joueur actuel
              if (!gameOver && !gamePaused)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(currentPlayer == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.transparent, 0.9)!,
                        Color.lerp(currentPlayer == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.transparent, 0.95)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.lerp(currentPlayer == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.transparent, 0.7)!,
                    ),
                  ),
                  child: Text(
                    'Tour du joueur: $currentPlayer',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentPlayer == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // plateau de jeu
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
                              Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.95)!,
                              Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9)!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.9)!,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              int row = index ~/ 3;
                              int col = index % 3;
                              bool isWinningCell = winningCells.any((cell) => cell[0] == row && cell[1] == col);
                              
                              return _buildGameCell(row, col, isWinningCell);
                            },
                          ),
                        ),
                      ),
                      
                      // Overlay Game Over/Pause
                      if (gameOver || gamePaused)
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
                                  animation: _rotationAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: gameOver ? _rotationAnimation.value * 2 * pi : 0,
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
                                            color: gameOver 
                                              ? (winner == 'X' ? CupertinoColors.systemBlue :
                                                 winner == 'O' ? CupertinoColors.systemRed : CupertinoColors.systemOrange)
                                              : CupertinoColors.systemBlue,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              gameOver 
                                                ? (winner == 'Match nul' ? '🤝 MATCH NUL!' : '🎉 $winner GAGNE!')
                                                : '⏸️ PAUSE',
                                              style: GoogleFonts.orbitron(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: gameOver 
                                                  ? (winner == 'X' ? CupertinoColors.systemBlue :
                                                     winner == 'O' ? CupertinoColors.systemRed : CupertinoColors.systemOrange)
                                                  : CupertinoColors.systemBlue,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            if (gameOver) ...[
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
              
              // instructions
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
                    color: Color.lerp(CupertinoColors.systemBlue, Colors.transparent, 0.7)!,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎯 Objectif: Alignez 3 symboles identiques',
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Horizontalement, verticalement ou en diagonale pour gagner!',
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

  Widget _buildGameCell(int row, int col, bool isWinning) {
    String cellValue = board[row][col];
    Color cellColor = isWinning 
      ? (winner == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed)
      : Colors.transparent;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => makeMove(row, col),
          child: Container(
            decoration: BoxDecoration(
              gradient: cellValue != '' ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(cellValue == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.white, 0.3)!,
                  cellValue == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed,
                ],
              ) : LinearGradient(
                colors: [
                  Color.lerp(CupertinoColors.systemGrey6, Colors.transparent, 0.5)!,
                  Color.lerp(CupertinoColors.systemGrey5, Colors.transparent, 0.7)!,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isWinning 
                  ? cellColor
                  : cellValue != '' 
                    ? Color.lerp(cellValue == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.white, 0.3)!
                    : Color.lerp(CupertinoColors.systemGrey4, Colors.transparent, 0.7)!,
                width: isWinning ? 3 : 2,
              ),
              boxShadow: cellValue != '' ? [
                BoxShadow(
                  color: Color.lerp(cellValue == 'X' ? CupertinoColors.systemBlue : CupertinoColors.systemRed, Colors.transparent, 0.7)!,
                  blurRadius: isWinning ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Center(
              child: Transform.scale(
                scale: cellValue != '' ? _scaleAnimation.value : 1.0,
                child: Text(
                  cellValue,
                  style: GoogleFonts.orbitron(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: cellValue == 'X' ? CupertinoColors.white : 
                           cellValue == 'O' ? CupertinoColors.white : Colors.transparent,
                    shadows: cellValue != '' ? [
                      Shadow(
                        color: Color.lerp(Colors.black, Colors.transparent, 0.7)!,
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ] : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// widget pour les stats du jeu
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
}