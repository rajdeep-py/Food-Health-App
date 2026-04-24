import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAction(
          context,
          title: 'Scan Food',
          icon: Iconsax.scan_barcode_copy,
          isPrimary: true,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening camera scanner...')),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildAction(
          context,
          title: 'Log Meal',
          icon: Iconsax.add_square_copy,
          isPrimary: false,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening manual entry...')),
            );
          },
        ),
        const SizedBox(width: 12),
        _buildAction(
          context,
          title: 'Suggestions',
          icon: Iconsax.magic_star_copy,
          isPrimary: false,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fetching AI suggestions...')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (isPrimary)
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
            border: isPrimary
                ? null
                : Border.all(color: theme.colorScheme.surfaceContainerHigh),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
