class StreakData {
  final int waterConsumed; // in glasses
  final int waterTarget; // in glasses
  final int cleanEatingStreak; // in days
  final int mealLoggingStreak; // in days

  const StreakData({
    required this.waterConsumed,
    required this.waterTarget,
    required this.cleanEatingStreak,
    required this.mealLoggingStreak,
  });
}
