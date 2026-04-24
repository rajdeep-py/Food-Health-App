class DailyInsight {
  final int healthScore; // 0 - 100
  final int caloriesConsumed;
  final int calorieTarget;
  final int proteinConsumed; // in grams
  final int proteinTarget;
  final int carbsConsumed;
  final int carbsTarget;
  final int fatsConsumed;
  final int fatsTarget;
  final String statusMessage; // e.g., "On track"
  final String contextualInsight; // e.g., "You're low on protein today"

  const DailyInsight({
    required this.healthScore,
    required this.caloriesConsumed,
    required this.calorieTarget,
    required this.proteinConsumed,
    required this.proteinTarget,
    required this.carbsConsumed,
    required this.carbsTarget,
    required this.fatsConsumed,
    required this.fatsTarget,
    required this.statusMessage,
    required this.contextualInsight,
  });
}
