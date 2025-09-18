import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:example/model/retro_game.dart';

class GameDialogHelpers {
  static void showPlayGameDialog(BuildContext context, RetroGame game) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.gamecontroller_fill, size: 20),
            const SizedBox(width: 8),
            Text(
              game.name,
              style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(game.description),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: game.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(game.icon, style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 10),
                  Text(
                    'Le jeu sera bientôt disponible !',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: game.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              showGameComingSoonModal(context, game);
            },
            child: const Text('Jouer'),
          ),
        ],
      ),
    );
  }

  static void showGameComingSoonModal(BuildContext context, RetroGame game) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🚀 '),
            Text(
              game.name,
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        message: const Text(
          'Ce jeu est en cours de développement.\nRevenez bientôt pour y jouer !',
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.bell_fill, size: 16),
                SizedBox(width: 8),
                Text('Me notifier quand c\'est prêt'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.device_phone_portrait, size: 16),
                SizedBox(width: 8),
                Text('Voir d\'autres jeux'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fermer'),
        ),
      ),
    );
  }
}
