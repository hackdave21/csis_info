import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games Services Demo'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
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
                color: isSignedIn ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSignedIn ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSignedIn ? Icons.check_circle : Icons.cancel,
                    color: isSignedIn ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isSignedIn ? 'Connecté: $playerName' : 'Non connecté',
                    style: TextStyle(
                      color: isSignedIn ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Boutons d'action
            ElevatedButton.icon(
              onPressed: _signIn,
              icon: const Icon(Icons.login),
              label: const Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: isSignedIn ? _showAchievements : null,
              icon: const Icon(Icons.emoji_events),
              label: const Text('Succès'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: isSignedIn ? _showLeaderboards : null,
              icon: const Icon(Icons.leaderboard),
              label: const Text('Classements'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSignedIn ? 'Connexion réussie!' : 'Échec de la connexion'),
            backgroundColor: isSignedIn ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isSignedIn = false;
        playerName = '';
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la connexion'),
            backgroundColor: Colors.red,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'affichage des succès')),
        );
      }
    }
  }

  Future<void> _showLeaderboards() async {
    try {
      await GamesServices.showLeaderboards();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'affichage des classements')),
        );
      }
    }
  }
}