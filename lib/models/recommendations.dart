class SmartRecommendation {
  final String id;
  final String suggestion; // e.g., "Swap white rice with brown rice today"
  final String benefit; // e.g., "+15% protein, higher fiber"
  final String actionText; // e.g., "Apply" or "View"

  const SmartRecommendation({
    required this.id,
    required this.suggestion,
    required this.benefit,
    required this.actionText,
  });
}
