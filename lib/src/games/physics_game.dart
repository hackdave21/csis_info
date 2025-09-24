
import 'package:csis_info/src/components/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';

class PhysicsGameWidget extends StatefulWidget {
  const PhysicsGameWidget({super.key});

  @override
  State<PhysicsGameWidget> createState() => _PhysicsGameWidgetState();
}

class _PhysicsGameWidgetState extends State<PhysicsGameWidget> {
  late MyPhysicsGame game;

  @override
  void initState() {
    super.initState();
    game = MyPhysicsGame();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('CSIS Physics Game'),
        backgroundColor: CupertinoColors.systemPurple,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton Pause/Play
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (game.paused) {
                  game.resumeEngine();
                } else {
                  game.pauseEngine();
                }
                setState(() {}); 
              },
              child: Icon(
                game.paused ? Icons.play_arrow : Icons.pause,
                color: CupertinoColors.white,
              ),
            ),
            // Bouton Redémarrer
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                game.onLoad();
                setState(() {});
              },
              child: const Icon(
                Icons.refresh,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: GameWidget.controlled(gameFactory: () => game),
      ),
    );
  }
}