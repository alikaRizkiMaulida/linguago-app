import 'package:linguago_flutter/data/streak/models/streak_task.dart';

class StreakRepository {
  static const List<String> weekDays = [
    'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa',
  ];

  static const int activeDay = 0; // Sunday

  int getStreakCount() => 1;

  double getProgress() => 1 / 7;

  List<StreakTask> getDailyTasks() => const [
        StreakTask(
          label: 'Login to the\napplication',
          points: '+2 study point',
        ),
        StreakTask(
          label: 'Watch 1 video\nlesson',
          points: '+4 study point',
        ),
        StreakTask(
          label: 'Complete 3 quiz\nsuccessfully',
          points: '+4 study point',
        ),
      ];
}
