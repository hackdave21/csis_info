import 'package:flutter/cupertino.dart';
import 'package:games_services/games_services.dart';

class GamesServicesDemo extends StatefulWidget {
  const GamesServicesDemo({super.key});

  @override
  State<GamesServicesDemo> createState() => _GamesServicesDemoState();
}

class _GamesServicesDemoState extends State<GamesServicesDemo> {
  bool isSignedIn = false;
  String playerName = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Games Services Demo'),
        backgroundColor: CupertinoColors.systemYellow,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.rosette, size: 100, color: CupertinoColors.systemYellow),
            const SizedBox(height: 20),
            const Text(
              'Games Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Intégration avec Google Play Games et Apple Game Center',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            
            // État de connexion
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSignedIn ? CupertinoColors.systemGreen.withOpacity(0.1) : CupertinoColors.systemRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSignedIn ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSignedIn ? CupertinoIcons.checkmark_circle : CupertinoIcons.xmark_circle,
                    color: isSignedIn ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isSignedIn ? 'Connecté: $playerName' : 'Non connecté',
                    style: TextStyle(
                      color: isSignedIn ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Boutons d'action
            CupertinoButton.filled(
              onPressed: _signIn,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.person_circle, color: CupertinoColors.white),
                  const SizedBox(width: 8),
                  const Text('Se connecter'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            CupertinoButton.filled(
              onPressed: isSignedIn ? _showAchievements : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.rosette, color: CupertinoColors.white),
                  const SizedBox(width: 8),
                  const Text('Succès'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            CupertinoButton.filled(
              onPressed: isSignedIn ? _showLeaderboards : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.chart_bar, color: CupertinoColors.white),
                  const SizedBox(width: 8),
                  const Text('Classements'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      final result = await GamesServices.signIn();
      setState(() {
        isSignedIn = result != null && result.isNotEmpty;
        if (isSignedIn) {
          playerName = result ?? 'Joueur'; 
        }
      });
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(isSignedIn ? 'Succès' : 'Erreur'),
            content: Text(isSignedIn ? 'Connexion réussie!' : 'Échec de la connexion'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        isSignedIn = false;
        playerName = '';
      });
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Erreur'),
            content: const Text('Erreur lors de la connexion'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _showAchievements() async {
    try {
      await GamesServices.showAchievements();
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Erreur'),
            content: const Text('Erreur lors de l\'affichage des succès'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _showLeaderboards() async {
    try {
      await GamesServices.showLeaderboards();
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Erreur'),
            content: const Text('Erreur lors de l\'affichage des classements'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }
}