import 'package:flutter/material.dart';
import 'package:linguago_flutter/ui/screens/listening/english_grid_screen.dart';

class EnglishScriptCategory {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final bool unlocked;
  final int? lockLevel;
  final String gridTitle;
  final String gridSubtitle;
  final EnglishGridMode mode;
  final List<EnglishItem> items;

  const EnglishScriptCategory({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    required this.lockLevel,
    required this.gridTitle,
    required this.gridSubtitle,
    required this.mode,
    required this.items,
  });
}
