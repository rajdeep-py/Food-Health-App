import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/insights/behaviour.dart';
import '../models/insights/health_score.dart';
import '../models/insights/nutrition_breakdown.dart';
import '../models/insights/pattern_detection.dart';
import '../models/insights/recommendations.dart';
import '../models/insights/summary.dart';

enum TimeFilter { daily, weekly, monthly }

class InsightsState {
  final TimeFilter timeFilter;
  final HealthScoreTrend? healthTrend;
  final NutritionBreakdown? nutritionBreakdown;
  final List<DetectedPattern> patterns;
  final List<ActionableRecommendation> recommendations;
  final List<BehaviourInsight> behaviours;
  final WeeklySummary? summary;
  final bool isLoading;
  final String? error;

  const InsightsState({
    this.timeFilter = TimeFilter.weekly,
    this.healthTrend,
    this.nutritionBreakdown,
    this.patterns = const [],
    this.recommendations = const [],
    this.behaviours = const [],
    this.summary,
    this.isLoading = true,
    this.error,
  });

  InsightsState copyWith({
    TimeFilter? timeFilter,
    HealthScoreTrend? healthTrend,
    NutritionBreakdown? nutritionBreakdown,
    List<DetectedPattern>? patterns,
    List<ActionableRecommendation>? recommendations,
    List<BehaviourInsight>? behaviours,
    WeeklySummary? summary,
    bool? isLoading,
    String? error,
  }) {
    return InsightsState(
      timeFilter: timeFilter ?? this.timeFilter,
      healthTrend: healthTrend ?? this.healthTrend,
      nutritionBreakdown: nutritionBreakdown ?? this.nutritionBreakdown,
      patterns: patterns ?? this.patterns,
      recommendations: recommendations ?? this.recommendations,
      behaviours: behaviours ?? this.behaviours,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class InsightsNotifier extends Notifier<InsightsState> {
  @override
  InsightsState build() {
    _fetchInsights(TimeFilter.weekly);
    return const InsightsState();
  }

  void setTimeFilter(TimeFilter filter) {
    state = state.copyWith(timeFilter: filter, isLoading: true);
    _fetchInsights(filter);
  }

  Future<void> _fetchInsights(TimeFilter filter) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final dummyHealthTrend = HealthScoreTrend(
        trendData: [
          HealthTrendPoint(1, 60),
          HealthTrendPoint(2, 65),
          HealthTrendPoint(3, 80), // Best day
          HealthTrendPoint(4, 75),
          HealthTrendPoint(5, 55), // Worst day
          HealthTrendPoint(6, 85),
          HealthTrendPoint(7, 90),
        ],
        interpretation: "Your health score improved by 8% this week.",
        isTrendingUp: true,
      );

      final dummyNutrition = NutritionBreakdown(
        macros: MacroDistribution(
          proteinPercentage: 25.0,
          carbsPercentage: 50.0,
          fatsPercentage: 25.0,
          interpretation: "Protein intake is 20% below optimal range.",
        ),
        dailyCalories: [2100, 2200, 1900, 2400, 2800, 2050, 2150],
        calorieTarget: 2200,
      );

      final dummyPatterns = [
        DetectedPattern(
          pattern: "You consume more carbs during dinner",
          impact: "Reduces sleep quality",
          confidence: 0.85,
        ),
        DetectedPattern(
          pattern: "Weekend calorie spikes detected",
          impact: "Slows weekly progress",
          confidence: 0.92,
        ),
      ];

      final dummyRecommendations = [
        ActionableRecommendation(
          title: "Breakfast Adjustment",
          action: "Increase protein by 25g in breakfast",
          benefit: "+10 health score improvement",
        ),
        ActionableRecommendation(
          title: "Hydration",
          action: "Drink 2 more glasses of water before 6 PM",
          benefit: "Better energy levels",
        ),
      ];

      final dummyBehaviours = [
        BehaviourInsight(
          title: "Consistency",
          description: "You log meals more consistently in the morning.",
          type: "positive",
        ),
        BehaviourInsight(
          title: "Late Night Cravings",
          description: "You tend to overeat after 8 PM.",
          type: "warning",
        ),
      ];

      final dummySummary = WeeklySummary(
        avgCalories: 2228,
        avgHealthScore: 72,
        bestDay: "Saturday",
        worstHabit: "Skipping breakfast",
      );

      state = state.copyWith(
        healthTrend: dummyHealthTrend,
        nutritionBreakdown: dummyNutrition,
        patterns: dummyPatterns,
        recommendations: dummyRecommendations,
        behaviours: dummyBehaviours,
        summary: dummySummary,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
