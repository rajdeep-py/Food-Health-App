class DetectedPattern {
  final String pattern; // "You consume more carbs during dinner"
  final String impact; // "Reduces sleep quality"
  final double confidence; // 0.0 to 1.0

  const DetectedPattern({
    required this.pattern,
    required this.impact,
    required this.confidence,
  });
}
