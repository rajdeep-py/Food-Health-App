class BehaviourInsight {
  final String title;
  final String description; // "You tend to overeat after 8 PM"
  final String type; // e.g. "warning", "positive"

  const BehaviourInsight({
    required this.title,
    required this.description,
    required this.type,
  });
}
