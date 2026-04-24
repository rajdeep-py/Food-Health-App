import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../providers/scanner_provider.dart';
import '../widgets/scanner/camera_overlay.dart';
import '../widgets/scanner/detection_label.dart';
import '../widgets/scanner/capture_button.dart';
import '../widgets/scanner/scan_mode_toggle.dart';
import '../cards/scanner/scanner_data_bottomsheet.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hintController;
  late Animation<double> _hintFade;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _hintFade = CurvedAnimation(parent: _hintController, curve: Curves.easeOut);

    // Simulate AI detection appearing after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(scannerProvider.notifier).simulateLiveDetection();
      }
    });
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  void _onCapture() {
    ref.read(scannerProvider.notifier).captureAndProcess();
  }

  void _showConfirmationSheet(BuildContext context) {
    final state = ref.read(scannerProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ScannerDataBottomsheet(
          foods: state.confirmedItems,
          onConfirm: () {
            Navigator.of(context).pop();
            ref.read(scannerProvider.notifier).confirmAndAnalyze();
          },
          onRemove: (index) {
            ref.read(scannerProvider.notifier).removeFood(index);
            Navigator.of(context).pop();
            // Re-open after rebuild so state is current
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showConfirmationSheet(context);
            });
          },
          onPortionUpdate: (index, portion) {
            ref.read(scannerProvider.notifier).updatePortion(index, portion);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scannerProvider);
    final size = MediaQuery.of(context).size;

    // Show confirmation sheet when entering confirming phase
    ref.listen<ScannerState>(scannerProvider, (previous, next) {
      if (previous?.phase != ScanPhase.confirming &&
          next.phase == ScanPhase.confirming) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showConfirmationSheet(context);
        });
      }
      if (previous?.phase != ScanPhase.done && next.phase == ScanPhase.done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showResultSnackbar(context, next);
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera Background (simulated dark green tinted preview) ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1628), Color(0xFF0D2137)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Simulated camera noise texture
          Opacity(
            opacity: 0.07,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20,
              ),
              itemCount: 400,
              itemBuilder: (_, i) => Container(
                color: i % 3 == 0 ? Colors.white : Colors.transparent,
              ),
            ),
          ),

          // ── Camera Overlay Frame + Scan Line ──
          CameraOverlay(isProcessing: state.phase == ScanPhase.processing),

          // ── AI Detection Labels (live) ──
          if (state.phase == ScanPhase.scanning &&
              state.detectedItems.isNotEmpty) ...[
            DetectionLabel(
              food: state.detectedItems[0],
              position: Offset(size.width * 0.12, size.height * 0.32),
            ),
            if (state.detectedItems.length > 1)
              DetectionLabel(
                food: state.detectedItems[1],
                position: Offset(size.width * 0.45, size.height * 0.52),
              ),
          ],

          // ── Processing State Overlay ──
          if (state.phase == ScanPhase.processing)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProcessingIndicator(label: 'Analyzing your meal…'),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AI identifying food items…',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          // ── Done State Overlay ──
          if (state.phase == ScanPhase.done)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Meal Logged!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.result?.confirmedCalories ?? 0} kcal added to your log',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(scannerProvider.notifier).reset();
                      context.go('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'View Dashboard',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          // ── TOP Overlay Controls ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TopIconButton(
                    icon: Iconsax.arrow_left_2_copy,
                    onTap: () => context.pop(),
                  ),
                  _TopIconButton(
                    icon: state.isFlashOn
                        ? Iconsax.flash_1_copy
                        : Iconsax.flash_slash_copy,
                    onTap: () =>
                        ref.read(scannerProvider.notifier).toggleFlash(),
                  ),
                  _TopIconButton(
                    icon: Iconsax.camera_copy,
                    onTap: () =>
                        ref.read(scannerProvider.notifier).toggleCamera(),
                  ),
                ],
              ),
            ),
          ),

          // ── HINT Text (below overlay frame) ──
          if (state.phase == ScanPhase.scanning)
            Positioned(
              bottom: size.height * 0.29,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _hintFade,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.hintText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── BOTTOM ACTION ZONE ──
          if (state.phase == ScanPhase.scanning)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scan mode toggle
                    ScanModeToggle(
                      currentMode: state.scanMode,
                      onChanged: (ScanMode mode) =>
                          ref.read(scannerProvider.notifier).setScanMode(mode),
                    ),
                    const SizedBox(height: 28),
                    // Capture + secondary actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gallery
                        _SecondaryActionButton(
                          icon: Iconsax.gallery_copy,
                          label: 'Gallery',
                          onTap: () {},
                        ),

                        // Main Capture Button
                        CaptureButton(onCapture: _onCapture),

                        // Manual Entry
                        _SecondaryActionButton(
                          icon: Iconsax.edit_copy,
                          label: 'Manual',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showResultSnackbar(BuildContext context, ScannerState state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ ${state.result?.confirmedCalories ?? 0} kcal logged successfully!',
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ── Helper Widgets ──

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
