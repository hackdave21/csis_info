
import 'package:csis_info/csis_info.dart';
import 'package:flutter/cupertino.dart';

class RetroGamesUtils {
  static List<RetroGame> getDefaultGames() {
    return [
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
      // RetroGame(
      //   name: 'Tic Tac Toe',
      //   description: 'Alignez 3 symboles identiques pour gagner la partie',
      //   icon: '❌',
      //   color: CupertinoColors.systemBlue,
      //   difficulty: 'Facile',
      //   players: '2 Joueurs',
      //   category: 'Stratégie',
      // ),
      // RetroGame(
      //   name: 'Memory',
      //   description: 'Trouvez toutes les paires en retournant les cartes',
      //   icon: '🧠',
      //   color: CupertinoColors.systemPurple,
      //   difficulty: 'Moyen',
      //   players: '1 Joueur',
      //   category: 'Réflexion',
      // ),
      // RetroGame(
      //   name: '2048',
      //   description: 'Glissez les tuiles pour atteindre 2048',
      //   icon: '🎯',
      //   color: CupertinoColors.systemYellow,
      //   difficulty: 'Moyen',
      //   players: '1 Joueur',
      //   category: 'Réflexion',
      // )
    ];
  }
}