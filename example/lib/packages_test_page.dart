import 'package:flutter/cupertino.dart';
import 'package:csis_info/src/widgets/csis_complete_demo.dart'; 

class PackagesTestPage extends StatelessWidget {
  const PackagesTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Tests des Paquets CSIS'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                CsisCompleteDemo()
                // section Jeux CSIS avec les plugins ajouté
                // Container(
                //   margin: const EdgeInsets.only(bottom: 20),
                //   child: const CsisGames(
                //     style: CsisGamesStyle.card,
                //     showHeader: true,
                //     showStats: true,
                //   ),
                // ),

              // jeux basiques developpés
              //  Container(
              //     margin: const EdgeInsets.only(bottom: 20),
              //     height: 600, 
              //     child: const RetroGamesPage(),
              //   ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

}