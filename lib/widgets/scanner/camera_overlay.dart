import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated scanning frame overlay drawn on top of the camera
class CameraOverlay extends StatefulWidget {
  final bool isProcessing;
  const CameraOverlay({super.key, this.isProcessing = false});

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, _) {
        return CustomPaint(
          painter: _OverlayPainter(
            scanProgress: _scanLineAnimation.value,
            isProcessing: widget.isProcessing,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double scanProgress;
  final bool isProcessing;

  _OverlayPainter({required this.scanProgress, required this.isProcessing});

  @override
  void paint(Canvas canvas, Size size) {
    final frameWidth = size.width * 0.75;
    final frameHeight = frameWidth * 0.85;
    final left = (size.width - frameWidth) / 2;
    final top = (size.height - frameHeight) / 2;
    final frameRect = Rect.fromLTWH(left, top, frameWidth, frameHeight);
    final frameRRect = RRect.fromRectAndRadius(
      frameRect,
      const Radius.circular(16),
    );

    // Dark overlay outside the frame
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final overlayPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(fullRect),
      Path()..addRRect(frameRRect),
    );
    canvas.drawPath(overlayPath, overlayPaint);

    // Corner brackets
    final cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 28.0;
    final r = 16.0;

    // Top-left
    canvas.drawLine(
      Offset(left + r, top),
      Offset(left + r + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + r),
      Offset(left, top + r + cornerLength),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(left + frameWidth - r - cornerLength, top),
      Offset(left + frameWidth - r, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top + r),
      Offset(left + frameWidth, top + r + cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(left + r, top + frameHeight),
      Offset(left + r + cornerLength, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + frameHeight - r - cornerLength),
      Offset(left, top + frameHeight - r),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(left + frameWidth - r - cornerLength, top + frameHeight),
      Offset(left + frameWidth - r, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top + frameHeight - r - cornerLength),
      Offset(left + frameWidth, top + frameHeight - r),
      cornerPaint,
    );

    // Scan line (animated)
    if (!isProcessing) {
      final scanY = top + (frameHeight * scanProgress);
      final scanLinePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF10B981).withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(left, scanY, frameWidth, 2));
      canvas.drawLine(
        Offset(left + 8, scanY),
        Offset(left + frameWidth - 8, scanY),
        scanLinePaint..strokeWidth = 2,
      );
    }

    // Processing pulse rings
    if (isProcessing) {
      final centerX = left + frameWidth / 2;
      final centerY = top + frameHeight / 2;
      final pulsePaint = Paint()
        ..color = const Color(
          0xFF10B981,
        ).withValues(alpha: 0.3 * (1 - scanProgress))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(
        Offset(centerX, centerY),
        40 + (scanProgress * 40),
        pulsePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) =>
      oldDelegate.scanProgress != scanProgress ||
      oldDelegate.isProcessing != isProcessing;
}

/// Spinning arc indicator for processing state
class ProcessingIndicator extends StatefulWidget {
  final String label;
  const ProcessingIndicator({super.key, this.label = 'Analyzing your meal…'});

  @override
  State<ProcessingIndicator> createState() => _ProcessingIndicatorState();
}

class _ProcessingIndicatorState extends State<ProcessingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Transform.rotate(
            angle: _ctrl.value * 2 * math.pi,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF10B981), width: 3),
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF10B981),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
