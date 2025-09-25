
import 'package:flutter/cupertino.dart';
import '../models/game_plugin.dart';

class PluginCard extends StatelessWidget {
  final GamePlugin plugin;
  final VoidCallback onTap;

  const PluginCard({
    super.key,
    required this.plugin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
       height: 300,
        child: Container(
         
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          decoration: BoxDecoration(
            color: plugin.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: plugin.color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: plugin.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(plugin.icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  plugin.name,
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // const SizedBox(height: 45),
              // Text(
              //   plugin.description,
              //   style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              //     fontSize: 12,
              //     color: CupertinoColors.systemGrey,
              //   ),
              //   textAlign: TextAlign.center,
              //   maxLines: 3,
              //   overflow: TextOverflow.ellipsis,
              // ),
              // const SizedBox(height: 8),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: plugin.color.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Text(
              //     plugin.category,
              //     style: TextStyle(
              //       fontSize: 10,
              //       color: plugin.color,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}