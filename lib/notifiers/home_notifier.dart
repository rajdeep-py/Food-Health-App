import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/insights.dart';
import '../models/plans.dart';
import '../models/recommendations.dart';
import '../models/streaks.dart';

class HomeState {
  final DailyInsight? insight;
  final List<MealPlan> meals;
  final List<SmartRecommendation> recommendations;
  final StreakData? streaks;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.insight,
    this.meals = const [],
    this.recommendations = const [],
    this.streaks,
    this.isLoading = true,
    this.error,
  });

  HomeState copyWith({
    DailyInsight? insight,
    List<MealPlan>? meals,
    List<SmartRecommendation>? recommendations,
    StreakData? streaks,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      insight: insight ?? this.insight,
      meals: meals ?? this.meals,
      recommendations: recommendations ?? this.recommendations,
      streaks: streaks ?? this.streaks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    _loadDashboardData();
    return const HomeState(isLoading: true);
  }

  Future<void> _loadDashboardData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final dummyInsight = const DailyInsight(
        healthScore: 78,
        caloriesConsumed: 1450,
        calorieTarget: 2200,
        proteinConsumed: 65,
        proteinTarget: 120,
        carbsConsumed: 150,
        carbsTarget: 250,
        fatsConsumed: 45,
        fatsTarget: 70,
        statusMessage: "Needs improvement",
        contextualInsight: "You're low on protein today.",
      );

      final dummyMeals = [
        const MealPlan(
          mealType: 'Breakfast',
          foodName: 'Oatmeal & Berries',
          calories: 350,
          healthColor: Colors.green,
          isLogged: true,
        ),
        const MealPlan(
          mealType: 'Lunch',
          foodName: 'Grilled Chicken Salad',
          calories: 450,
          healthColor: Colors.green,
          isLogged: true,
        ),
        const MealPlan(
          mealType: 'Snack',
          foodName: 'Potato Chips',
          calories: 200,
          healthColor: Colors.orange,
          isLogged: true,
        ),
        const MealPlan(
          mealType: 'Dinner',
          foodName: 'Unlogged',
          calories: 0,
          healthColor: Colors.grey,
          isLogged: false,
        ),
      ];

      final dummyRecommendations = [
        const SmartRecommendation(
          id: '1',
          suggestion: 'Swap potato chips with mixed nuts',
          benefit: '+10g protein, healthy fats',
          actionText: 'Apply',
        ),
        const SmartRecommendation(
          id: '2',
          suggestion: 'Drink 2 more glasses of water',
          benefit: 'Reach daily hydration goal',
          actionText: 'Track',
        ),
      ];

      final dummyStreaks = const StreakData(
        waterConsumed: 4,
        waterTarget: 8,
        cleanEatingStreak: 5,
        mealLoggingStreak: 12,
      );

      state = state.copyWith(
        insight: dummyInsight,
        meals: dummyMeals,
        recommendations: dummyRecommendations,
        streaks: dummyStreaks,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void addWater() {
    if (state.streaks == null) return;
    final currentStreaks = state.streaks!;
    final updatedStreaks = StreakData(
      waterConsumed: currentStreaks.waterConsumed + 1,
      waterTarget: currentStreaks.waterTarget,
      cleanEatingStreak: currentStreaks.cleanEatingStreak,
      mealLoggingStreak: currentStreaks.mealLoggingStreak,
    );
    state = state.copyWith(streaks: updatedStreaks);
  }
}
