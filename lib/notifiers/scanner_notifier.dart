import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scanner/detected_food.dart';
import '../models/scanner/scan_result.dart';

enum ScanPhase { scanning, processing, confirming, done }

class ScannerState {
  final ScanPhase phase;
  final ScanMode scanMode;
  final bool isFlashOn;
  final bool isFrontCamera;
  final List<DetectedFood> detectedItems; // live detection labels
  final List<DetectedFood> confirmedItems; // post-capture editable list
  final ScanResult? result;
  final String hintText;

  const ScannerState({
    this.phase = ScanPhase.scanning,
    this.scanMode = ScanMode.foodScan,
    this.isFlashOn = false,
    this.isFrontCamera = false,
    this.detectedItems = const [],
    this.confirmedItems = const [],
    this.result,
    this.hintText = 'Align your food within the frame',
  });

  ScannerState copyWith({
    ScanPhase? phase,
    ScanMode? scanMode,
    bool? isFlashOn,
    bool? isFrontCamera,
    List<DetectedFood>? detectedItems,
    List<DetectedFood>? confirmedItems,
    ScanResult? result,
    String? hintText,
  }) {
    return ScannerState(
      phase: phase ?? this.phase,
      scanMode: scanMode ?? this.scanMode,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      detectedItems: detectedItems ?? this.detectedItems,
      confirmedItems: confirmedItems ?? this.confirmedItems,
      result: result ?? this.result,
      hintText: hintText ?? this.hintText,
    );
  }
}

class ScannerNotifier extends Notifier<ScannerState> {
  @override
  ScannerState build() => const ScannerState();

  void toggleFlash() {
    state = state.copyWith(isFlashOn: !state.isFlashOn);
  }

  void toggleCamera() {
    state = state.copyWith(isFrontCamera: !state.isFrontCamera);
  }

  void setScanMode(ScanMode mode) {
    state = state.copyWith(scanMode: mode);
  }

  // Simulate live detection appearing on camera
  void simulateLiveDetection() {
    state = state.copyWith(
      hintText: 'Hold steady…',
      detectedItems: const [
        DetectedFood(
          name: 'Chicken Curry',
          confidence: 0.87,
          estimatedCalories: 320,
          portion: '1 bowl',
          labelColor: Color(0xFF10B981),
        ),
        DetectedFood(
          name: 'White Rice',
          confidence: 0.72,
          estimatedCalories: 210,
          portion: '1 cup',
          labelColor: Color(0xFFF59E0B),
        ),
      ],
    );
  }

  void clearLiveDetection() {
    state = state.copyWith(
      detectedItems: const [],
      hintText: 'Align your food within the frame',
    );
  }

  Future<void> captureAndProcess() async {
    // Move to processing phase
    state = state.copyWith(
      phase: ScanPhase.processing,
      detectedItems: const [],
    );

    // Simulate AI processing delay (1.5 sec)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Move to confirmation phase with dummy detected foods
    const detectedFoods = [
      DetectedFood(
        name: 'Chicken Curry',
        confidence: 0.87,
        estimatedCalories: 320,
        portion: '1 bowl',
        labelColor: Color(0xFF10B981),
      ),
      DetectedFood(
        name: 'Steamed Rice',
        confidence: 0.79,
        estimatedCalories: 210,
        portion: '1 cup',
        labelColor: Color(0xFF10B981),
      ),
      DetectedFood(
        name: 'Dal',
        confidence: 0.65,
        estimatedCalories: 130,
        portion: '½ cup',
        labelColor: Color(0xFFF59E0B),
      ),
    ];

    state = state.copyWith(
      phase: ScanPhase.confirming,
      confirmedItems: detectedFoods,
    );
  }

  void removeFood(int index) {
    final updated = List<DetectedFood>.from(state.confirmedItems)
      ..removeAt(index);
    state = state.copyWith(confirmedItems: updated);
  }

  void updatePortion(int index, String newPortion) {
    final updated = List<DetectedFood>.from(state.confirmedItems);
    updated[index] = updated[index].copyWith(portion: newPortion);
    state = state.copyWith(confirmedItems: updated);
  }

  void confirmAndAnalyze() {
    final hour = DateTime.now().hour;
    MealType mealType;
    if (hour < 10) {
      mealType = MealType.breakfast;
    } else if (hour < 14) {
      mealType = MealType.lunch;
    } else if (hour < 18) {
      mealType = MealType.snack;
    } else {
      mealType = MealType.dinner;
    }

    final result = ScanResult(
      foods: state.confirmedItems,
      suggestedMealType: mealType,
      totalCalories: state.confirmedItems.fold(
        0,
        (s, f) => s + f.estimatedCalories,
      ),
      capturedAt: DateTime.now(),
    );

    state = state.copyWith(phase: ScanPhase.done, result: result);
  }

  void reset() {
    state = const ScannerState();
  }
}
