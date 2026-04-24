class HealthTrendPoint {
  final int day; // e.g., 1 to 7 for weekly
  final double score;

  const HealthTrendPoint(this.day, this.score);
}

class HealthScoreTrend {
  final List<HealthTrendPoint> trendData;
  final String interpretation; // "Your health score improved by 8% this week"
  final bool isTrendingUp;

  const HealthScoreTrend({
    required this.trendData,
    required this.interpretation,
    required this.isTrendingUp,
  });
}
