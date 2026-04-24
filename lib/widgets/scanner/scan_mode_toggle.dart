import 'package:flutter/material.dart';
import '../../models/scanner/detected_food.dart';

/// Swipeable/segmented mode toggle: Food Scan / Barcode / AI Auto
class ScanModeToggle extends StatelessWidget {
  final ScanMode currentMode;
  final ValueChanged<ScanMode> onChanged;

  const ScanModeToggle({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  static final _labels = {
    ScanMode.foodScan: 'Food Scan',
    ScanMode.barcodeScan: 'Barcode',
    ScanMode.mealRecognition: 'AI Auto',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ScanMode.values.map((mode) {
          final isSelected = mode == currentMode;
          return GestureDetector(
            onTap: () => onChanged(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF10B981)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labels[mode]!,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
