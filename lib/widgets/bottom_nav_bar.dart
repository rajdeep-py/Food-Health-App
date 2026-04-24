import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of icons and labels for the 5 tabs
    final List<Map<String, dynamic>> items = [
      {
        'icon': Iconsax.home_2_copy,
        'activeIcon': Iconsax.home_2,
        'label': 'Home',
      },
      {
        'icon': Iconsax.chart_2_copy,
        'activeIcon': Iconsax.chart_2,
        'label': 'Insights',
      },
      {
        'icon': Iconsax.scan_barcode_copy,
        'activeIcon': Iconsax.scan_barcode,
        'label': 'Scan',
      }, // Center special item
      {
        'icon': Iconsax.calendar_1_copy,
        'activeIcon': Iconsax.calendar_1,
        'label': 'Planner',
      },
      {
        'icon': Iconsax.profile_circle_copy,
        'activeIcon': Iconsax.profile_circle,
        'label': 'Profile',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];
              final bool isCenter = index == 2; // "Log / Scan" is at index 2

              if (isCenter) {
                // Prominent central button for Log / Scan
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? item['activeIcon'] : item['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              }

              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Indicator Dot
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 4),
                        height: 4,
                        width: isSelected ? 16 : 0,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isSelected ? item['activeIcon'] : item['icon'],
                          key: ValueKey<bool>(isSelected),
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
