import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/streaks.dart';

class StreaksCard extends StatelessWidget {
  final StreakData streaks;
  final VoidCallback onAddWater;

  const StreaksCard({
    super.key,
    required this.streaks,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waterProgress = streaks.waterConsumed / streaks.waterTarget;

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
                'Habits & Streaks',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '${streaks.cleanEatingStreak} Days ',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('🔥', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.drop,
                          size: 16,
                          color: const Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Water Intake',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${streaks.waterConsumed}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / ${streaks.waterTarget} glasses',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: waterProgress > 1.0 ? 1.0 : waterProgress,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHigh,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Material(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onAddWater,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.add, color: Color(0xFF3B82F6)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
