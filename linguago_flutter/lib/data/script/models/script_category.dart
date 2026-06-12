import 'package:flutter/material.dart';

class HangulCategory {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final bool unlocked;
  final int? lockLevel;

  const HangulCategory({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    this.lockLevel,
  });
}
