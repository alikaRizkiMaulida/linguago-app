import 'package:flutter/material.dart';

class Achievement {
  final String svgAsset;
  final String title;
  final bool unlocked;
  final double progress;
  final Color color;

  const Achievement({
    required this.svgAsset,
    required this.title,
    this.unlocked = false,
    this.progress = 0.0,
    this.color = Colors.transparent,
  });
}
