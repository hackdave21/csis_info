
import 'package:flutter/cupertino.dart';
// import 'package:flame/game.dart'; 

class PackagesTestPage extends StatelessWidget {
  const PackagesTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Tests des Paquets'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children:  [
                 
              ],
            ),
          ),
        ),
      ),
    );
  }
}