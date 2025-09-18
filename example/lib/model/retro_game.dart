
import 'package:flutter/cupertino.dart';

class RetroGame {
  final String name;
  final String description;
  final String icon; 
  final Color color;
  final String difficulty;
  final String players;
  final String category;

  RetroGame({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.players,
    required this.category,
  });
}