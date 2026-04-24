import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/insights.dart';
import '../../models/user.dart';

class GreetingCard extends StatelessWidget {
  final User? user;
  final DailyInsight? insight;

  const GreetingCard({super.key, this.user, this.insight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user?.name?.split(' ').first ?? 'User';
    final warningInsight =
        insight?.contextualInsight ?? "You're doing great today!";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,\n$name',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.warning_2_copy,
                      size: 14,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        warningInsight,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceContainerHigh,
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            image: const DecorationImage(
              image: NetworkImage(
                'https://i.pravatar.cc/150?img=11',
              ), // Dummy avatar
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
