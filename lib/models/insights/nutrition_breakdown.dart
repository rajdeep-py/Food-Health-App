class MacroDistribution {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatsPercentage;
  final String interpretation;

  const MacroDistribution({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatsPercentage,
    required this.interpretation,
  });
}

class NutritionBreakdown {
  final MacroDistribution macros;
  final List<double> dailyCalories; // Last 7 days calories
  final double calorieTarget;

  const NutritionBreakdown({
    required this.macros,
    required this.dailyCalories,
    required this.calorieTarget,
  });
}
