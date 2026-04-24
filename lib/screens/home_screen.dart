import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/home_provider.dart';
import '../theme/app_theme.dart';
import '../cards/home/greeting_card.dart';
import '../cards/home/daily_summary_card.dart';
import '../cards/home/quick_actions_card.dart';
import '../cards/home/todays_plan_card.dart';
import '../cards/home/smart_recommendations_card.dart';
import '../cards/home/streaks_card.dart';
import '../cards/home/mini_insights_card.dart';
import '../cards/home/footer_card.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading dashboard: ${state.error}')),
      );
    }

    return Scaffold(
      appBar: const ModernAppBar(
        title: 'Dashboard',
        subtitle: 'Your personal health engine',
        showBackButton: false,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            context.go('/insights');
          }
        },
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingCard(insight: state.insight),
                const SizedBox(height: 32),

                if (state.insight != null) ...[
                  DailySummaryCard(insight: state.insight!),
                  const SizedBox(height: 24),
                ],

                const QuickActionsCard(),
                const SizedBox(height: 32),

                if (state.meals.isNotEmpty) ...[
                  TodaysPlanCard(meals: state.meals),
                  const SizedBox(height: 32),
                ],

                if (state.recommendations.isNotEmpty) ...[
                  SmartRecommendationsCard(
                    recommendations: state.recommendations,
                  ),
                  const SizedBox(height: 32),
                ],

                if (state.streaks != null) ...[
                  StreaksCard(
                    streaks: state.streaks!,
                    onAddWater: () {
                      ref.read(homeProvider.notifier).addWater();
                    },
                  ),
                  const SizedBox(height: 32),
                ],

                const MiniInsightsCard(),
                const SizedBox(height: 16),
                const FooterCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
