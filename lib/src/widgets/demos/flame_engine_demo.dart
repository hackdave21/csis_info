import 'package:flutter/cupertino.dart';

class FlameEngineDemo extends StatelessWidget {
  const FlameEngineDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flame Engine Demo'),
        backgroundColor: CupertinoColors.systemOrange,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.flame, size: 100, color: CupertinoColors.systemOrange),
            const SizedBox(height: 20),
            const Text(
              'Flame Game Engine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Moteur de jeu 2D complet avec physique, audio, et plus',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.separator,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fonctionnalités Flame:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('🎨', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Sprites et animations')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('⚡', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Physique avec Forge2D')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('🔊', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Audio et effets sonores')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('💥', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Détection de collisions')),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('✨', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Système de particules')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}