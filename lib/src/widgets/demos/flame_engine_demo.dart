import 'package:flutter/material.dart';

class FlameEngineDemo extends StatelessWidget {
  const FlameEngineDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flame Engine Demo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.whatshot, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Flame Game Engine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Moteur de jeu 2D complet avec physique, audio, et plus',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Fonctionnalités:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('• Sprites et animations'),
                    Text('• Physique avec Forge2D'),
                    Text('• Audio et effets sonores'),
                    Text('• Détection de collisions'),
                    Text('• Système de particules'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}