import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class FooterCard extends StatelessWidget {
  const FooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Icon(
            Iconsax.heart_copy,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            "You're doing great!",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep up the healthy habits.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
