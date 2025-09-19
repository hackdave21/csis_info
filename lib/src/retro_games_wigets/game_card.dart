import 'package:csis_info/retro_games.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameCard extends StatelessWidget {
  final RetroGame game;
  final int index;
  final bool isDarkMode;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.index,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? CupertinoColors.systemGrey6.darkColor
                : CupertinoColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(game.color, Colors.transparent, 0.8)!,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          game.color, 
                          Color.lerp(game.color, Colors.white, 0.3)!
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Color.lerp(game.color, Colors.transparent, 0.7)!,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(game.icon, style: TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: GoogleFonts.orbitron(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.description,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: isDarkMode
                                ? CupertinoColors.systemGrey
                                : CupertinoColors.systemGrey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.lerp(game.color, Colors.transparent, 0.9)!,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      CupertinoIcons.play_fill,
                      color: game.color,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  GameTag(
                    text: game.difficulty,
                    color: CupertinoColors.systemOrange,
                  ),
                  const SizedBox(width: 8),
                  GameTag(
                    text: game.players,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 8),
                  GameTag(
                    text: game.category,
                    color: CupertinoColors.systemPurple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameTag extends StatelessWidget {
  final String text;
  final Color color;

  const GameTag({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color.lerp(color, Colors.transparent, 0.85)!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.lerp(color, Colors.transparent, 0.7)!),
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}