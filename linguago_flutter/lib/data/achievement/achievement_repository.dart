import 'package:flutter/material.dart';
import 'package:linguago_flutter/data/achievement/models/achievement.dart';

class AchievementRepository {
  static const _data = [
    Achievement(svgAsset: 'assets/Group 36772.svg', title: 'Try all learning\nfeatures', unlocked: true, progress: 1.0, color: Color(0xFF7EC8E3)),
    Achievement(svgAsset: 'assets/Group 36773.svg', title: 'Answer\nquizzes quickly', unlocked: true, progress: 1.0, color: Color(0xFFFFDFA0)),
    Achievement(svgAsset: 'assets/Group 36774.svg', title: 'Completed\nlessons', unlocked: true, progress: 1.0, color: Color(0xFFC8A2C8)),
    Achievement(svgAsset: 'assets/Group 36775.svg', title: 'Unlimited quiz\nhearts', unlocked: true, progress: 1.0, color: Color(0xFFFFB3BA)),
    Achievement(svgAsset: 'assets/Group 36776-1.svg', title: 'Maintain a long\nlearning streak', unlocked: true, progress: 1.0, color: Color(0xFFE57373)),
    Achievement(svgAsset: 'assets/Group 36778.svg', title: 'Reach top 3 on\nleaderboard'),
    Achievement(svgAsset: 'assets/Group 36779.svg', title: 'Complete many\nreading lessons'),
    Achievement(svgAsset: 'assets/Group 36780.svg', title: 'Keep learning\nafter quizzes'),
    Achievement(svgAsset: 'assets/Group 36780-1.svg', title: 'Reach rank #1\non leaderboard'),
    Achievement(svgAsset: 'assets/Group 36781.svg', title: 'Finish lessons\nsmoothly'),
    Achievement(svgAsset: 'assets/Group 36785.svg', title: 'Collect many\ngems/rewards'),
    Achievement(svgAsset: 'assets/Group 36786.svg', title: 'Complete a full\nlesson perfectly'),
    Achievement(svgAsset: 'assets/Group 36796.svg', title: 'Maintain a long\nlearning streak'),
    Achievement(svgAsset: 'assets/Group 36787.svg', title: 'Reach rank #2\non leaderboard'),
    Achievement(svgAsset: 'assets/Group 36788.svg', title: 'Get multiple\ncorrect answers'),
  ];

  List<Achievement> getAchievements() => List.unmodifiable(_data);
}
