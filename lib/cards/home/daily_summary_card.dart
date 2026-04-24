import 'package:flutter/material.dart';
import '../../models/insights.dart';

class DailySummaryCard extends StatelessWidget {
  final DailyInsight insight;

  const DailySummaryCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate progress
    double scoreProgress = insight.healthScore / 100.0;

    // Determine color based on score
    Color scoreColor = theme.colorScheme.error;
    if (scoreProgress > 0.8) {
      scoreColor = theme.colorScheme.primary;
    } else if (scoreProgress > 0.5) {
      scoreColor = theme.colorScheme.secondary;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scoreColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        insight.statusMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.more_horiz,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Health Score
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: CircularProgressIndicator(
                        value: scoreProgress,
                        strokeWidth: 8,
                        backgroundColor: theme.colorScheme.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${insight.healthScore}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'Score',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Calorie details
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${insight.caloriesConsumed}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/ ${insight.calorieTarget} kcal',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Macro Splits
          Row(
            children: [
              _buildMacroItem(
                context,
                'Protein',
                insight.proteinConsumed,
                insight.proteinTarget,
                theme.colorScheme.secondary, // Amber
              ),
              const SizedBox(width: 16),
              _buildMacroItem(
                context,
                'Carbs',
                insight.carbsConsumed,
                insight.carbsTarget,
                const Color(0xFF3B82F6), // Blue
              ),
              const SizedBox(width: 16),
              _buildMacroItem(
                context,
                'Fats',
                insight.fatsConsumed,
                insight.fatsTarget,
                theme.colorScheme.error, // Red
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(
    BuildContext context,
    String title,
    int consumed,
    int target,
    Color color,
  ) {
    final theme = Theme.of(context);
    double progress = consumed / target;
    if (progress > 1.0) progress = 1.0;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '${consumed}g',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
