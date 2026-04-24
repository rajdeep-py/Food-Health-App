import 'detected_food.dart';

enum MealType { breakfast, lunch, dinner, snack }

class ScanResult {
  final List<DetectedFood> foods;
  final MealType suggestedMealType;
  final int totalCalories;
  final DateTime capturedAt;

  const ScanResult({
    required this.foods,
    required this.suggestedMealType,
    required this.totalCalories,
    required this.capturedAt,
  });

  int get confirmedCalories =>
      foods.fold(0, (sum, f) => sum + f.estimatedCalories);
}
