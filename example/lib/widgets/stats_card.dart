import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsCard extends StatelessWidget {
  final bool isDarkMode;

  const StatsCard({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? CupertinoColors.systemGrey6.darkColor 
            : CupertinoColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
           icon: CupertinoIcons.star_fill,
            label: 'Meilleur Score',
            value: '12,450',
            isDarkMode: isDarkMode,
          ),
          _StatItem(
            icon: CupertinoIcons.bolt_fill,
            label: 'Parties Jouées',
            value: '47',
            isDarkMode: isDarkMode,
          ),
          _StatItem(
            icon: CupertinoIcons.gauge,
            label: 'Précision',
            value: '85%',
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDarkMode;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 25,
          color: isDarkMode ? CupertinoColors.systemYellow : CupertinoColors.systemBlue,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: isDarkMode 
                ? CupertinoColors.systemGrey 
                : CupertinoColors.systemGrey2,
          ),
        ),
      ],
    );
  }
}