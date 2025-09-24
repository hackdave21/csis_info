
import 'package:flutter/cupertino.dart';
import '../models/game_plugin.dart';
import 'plugin_card.dart';

class PluginGrid extends StatefulWidget {
  final List<GamePlugin> plugins;
  final Function(GamePlugin) onPluginTap;

  const PluginGrid({
    super.key,
    required this.plugins,
    required this.onPluginTap,
  });

  @override
  State<PluginGrid> createState() => _PluginGridState();
}

class _PluginGridState extends State<PluginGrid> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
            setState(() {});
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => PluginCard(
                plugin: widget.plugins[index],
                onTap: () => widget.onPluginTap(widget.plugins[index]),
              ),
              childCount: widget.plugins.length,
            ),
          ),
        ),
      ],
    );
  }
}