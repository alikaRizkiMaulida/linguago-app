class StreakTask {
  final String label;
  final String points;
  final bool done;

  const StreakTask({
    required this.label,
    required this.points,
    this.done = false,
  });
}
