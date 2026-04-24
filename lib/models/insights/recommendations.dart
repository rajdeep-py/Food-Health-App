class ActionableRecommendation {
  final String title;
  final String action; // "Increase protein by 25g in breakfast"
  final String benefit; // "+10 health score improvement"

  const ActionableRecommendation({
    required this.title,
    required this.action,
    required this.benefit,
  });
}
