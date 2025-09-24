
import 'package:flutter/cupertino.dart';

class GamePlugin {
  final String name;
  final String description;
  final String icon;
  final Color color;
  final String category;
  final Widget Function() demoWidget;

  GamePlugin({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.demoWidget,
  });
}