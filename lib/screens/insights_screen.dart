import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/insights_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../cards/insights/time_filter_card.dart';
import '../cards/insights/health_score_card.dart';
import '../cards/insights/nutrition_breakdown_card.dart';
import '../cards/insights/pattern_detection_card.dart';
import '../cards/insights/smart_recommendations_card.dart';
import '../cards/insights/behaviour_insights_card.dart';
import '../cards/insights/summary_report_card.dart';
import '../cards/insights/footer_card.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(insightsProvider);

    return Scaffold(
      appBar: const ModernAppBar(
        title: 'Insights',
        subtitle: 'AI-driven health analysis',
        showBackButton: false,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) context.push('/scanner');
        },
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: state.isLoading && state.healthTrend == null
              ? const Center(child: CircularProgressIndicator())
              : state.error != null
              ? Center(child: Text('Error loading insights: ${state.error}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeFilterCard(
                        currentFilter: state.timeFilter,
                        onFilterChanged: (filter) {
                          ref
                              .read(insightsProvider.notifier)
                              .setTimeFilter(filter);
                        },
                      ),
                      const SizedBox(height: 32),

                      if (state.healthTrend != null) ...[
                        HealthScoreCard(trend: state.healthTrend!),
                        const SizedBox(height: 32),
                      ],

                      if (state.nutritionBreakdown != null) ...[
                        NutritionBreakdownCard(
                          breakdown: state.nutritionBreakdown!,
                        ),
                        const SizedBox(height: 32),
                      ],

                      if (state.patterns.isNotEmpty) ...[
                        PatternDetectionCard(patterns: state.patterns),
                        const SizedBox(height: 32),
                      ],

                      if (state.recommendations.isNotEmpty) ...[
                        SmartRecommendationsCard(
                          recommendations: state.recommendations,
                        ),
                        const SizedBox(height: 32),
                      ],

                      if (state.behaviours.isNotEmpty) ...[
                        BehaviourInsightsCard(behaviours: state.behaviours),
                        const SizedBox(height: 32),
                      ],

                      if (state.summary != null) ...[
                        SummaryReportCard(summary: state.summary!),
                        const SizedBox(height: 16),
                      ],

                      const InsightsFooterCard(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
