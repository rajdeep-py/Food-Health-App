import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/insights/behaviour.dart';

class BehaviourInsightsCard extends StatelessWidget {
  final List<BehaviourInsight> behaviours;

  const BehaviourInsightsCard({super.key, required this.behaviours});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (behaviours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Psychology & Habits',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...behaviours.map((b) => _buildBehaviourItem(context, b)),
      ],
    );
  }

  Widget _buildBehaviourItem(BuildContext context, BehaviourInsight behaviour) {
    final theme = Theme.of(context);
    final isPositive = behaviour.type == 'positive';
    final color = isPositive
        ? theme.colorScheme.primary
        : theme.colorScheme.error;
    final icon = isPositive ? Iconsax.like_1_copy : Iconsax.warning_2_copy;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  behaviour.title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  behaviour.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
