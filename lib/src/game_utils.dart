import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:flame_audio/flame_audio.dart';

class CSISGameUtils {
  
  /// initialise les services de jeu 
  static Future<void> initializeGameServices() async {
    try {
      await GamesServices.signIn();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation des services de jeu: $e');
    }
  }

  /// débloque un achievement
  static Future<void> unlockAchievement(String achievementId) async {
    try {
      await GamesServices.unlock(achievement: Achievement(androidID: achievementId));
    } catch (e) {
      debugPrint('Erreur lors du débloquage de l\'achievement: $e');
    }
  }

  /// soumet un score au leaderboard
  static Future<void> submitScore(String leaderboardId, int score) async {
    try {
      await GamesServices.submitScore(
        score: Score(
          androidLeaderboardID: leaderboardId,
          value: score,
        ),
      );
    } catch (e) {
      debugPrint('Erreur lors de la soumission du score: $e');
    }
  }

  /// joue un son d'effet
  static Future<void> playSound(String soundPath) async {
    try {
      await FlameAudio.play(soundPath);
    } catch (e) {
      debugPrint('Erreur lors de la lecture du son: $e');
    }
  }

  /// joue une musique de fond
  static Future<void> playBackgroundMusic(String musicPath) async {
    try {
      await FlameAudio.playLongAudio(musicPath);
    } catch (e) {
      debugPrint('Erreur lors de la lecture de la musique: $e');
    }
  }

  /// arrête la musique de fond
  static Future<void> stopBackgroundMusic() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (e) {
      debugPrint('Erreur lors de l\'arrêt de la musique: $e');
    }
  }
}