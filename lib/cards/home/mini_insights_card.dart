import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MiniInsightsCard extends StatelessWidget {
  const MiniInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Iconsax.chart_21_copy,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightRow(
            context,
            icon: Iconsax.trend_up_copy,
            color: theme.colorScheme.error,
            text: 'You consumed 18% more sugar this week.',
          ),
          const SizedBox(height: 12),
          _buildInsightRow(
            context,
            icon: Iconsax.trend_up_copy,
            color: theme.colorScheme.primary,
            text: 'Protein intake improved by 12%.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: const Text('View full insights →'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String text,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
