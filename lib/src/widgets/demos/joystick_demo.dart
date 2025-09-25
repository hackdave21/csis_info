import 'package:flutter/cupertino.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickDemo extends StatefulWidget {
  const JoystickDemo({super.key});

  @override
  State<JoystickDemo> createState() => _JoystickDemoState();
}

class _JoystickDemoState extends State<JoystickDemo> {
  double playerX = 0;
  double playerY = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Flutter Joystick Demo'),
        backgroundColor: CupertinoColors.systemBlue,
      ),
      child: Stack(
        children: [
          // Zone de jeu
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemGreen.withOpacity(0.2), 
                  CupertinoColors.systemBlue.withOpacity(0.2)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Grille de fond
                CustomPaint(
                  size: Size.infinite,
                  painter: GridPainter(),
                ),
                
                // Joueur
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: MediaQuery.of(context).size.width / 2 + playerX * 120,
                  top: MediaQuery.of(context).size.height / 2 + playerY * 120,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [CupertinoColors.systemBlue, CupertinoColors.activeBlue],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemBlue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🚀', style: TextStyle(fontSize: 30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Joystick
          Positioned(
            bottom: 80,
            left: 50,
            child: Joystick(
              listener: (details) {
                setState(() {
                  playerX = details.x;
                  playerY = details.y;
                });
              },
              base: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: CupertinoColors.systemBlue, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              stick: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CupertinoColors.systemBlue, CupertinoColors.activeBlue],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Informations
          Positioned(
            top: 120, // Ajusté pour éviter la navigation bar
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Position:', 
                    style: TextStyle(
                      color: CupertinoColors.white, 
                      fontWeight: FontWeight.bold
                    )),
                  const SizedBox(height: 5),
                  Text('X: ${playerX.toStringAsFixed(2)}', 
                    style: const TextStyle(color: CupertinoColors.activeBlue)),
                  Text('Y: ${playerY.toStringAsFixed(2)}', 
                    style: const TextStyle(color: CupertinoColors.activeBlue)),
                  const SizedBox(height: 10),
                  Text('Distance: ${(playerX.abs() + playerY.abs()).toStringAsFixed(2)}',
                    style: const TextStyle(color: CupertinoColors.systemOrange)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.systemGrey.withOpacity(0.1)
      ..strokeWidth = 1;

    const spacing = 50.0;
    
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}