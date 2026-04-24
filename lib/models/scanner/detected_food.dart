import 'package:flutter/material.dart';

enum ScanMode { foodScan, barcodeScan, mealRecognition }

class DetectedFood {
  final String name;
  final double confidence; // 0.0 to 1.0
  final int estimatedCalories;
  final String portion; // e.g. "1 bowl", "2 pieces"
  final Color labelColor;

  const DetectedFood({
    required this.name,
    required this.confidence,
    required this.estimatedCalories,
    required this.portion,
    this.labelColor = const Color(0xFF10B981),
  });

  DetectedFood copyWith({String? portion}) {
    return DetectedFood(
      name: name,
      confidence: confidence,
      estimatedCalories: estimatedCalories,
      portion: portion ?? this.portion,
      labelColor: labelColor,
    );
  }

  int get confidencePercent => (confidence * 100).toInt();
}
