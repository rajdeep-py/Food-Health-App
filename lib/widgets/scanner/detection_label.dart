import 'package:flutter/material.dart';
import '../../models/scanner/detected_food.dart';

/// Floating AI detection label chip shown on the camera preview
class DetectionLabel extends StatefulWidget {
  final DetectedFood food;
  final Offset position; // relative position on screen

  const DetectionLabel({super.key, required this.food, required this.position});

  @override
  State<DetectionLabel> createState() => _DetectionLabelState();
}

class _DetectionLabelState extends State<DetectionLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeScale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeScale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: FadeTransition(
        opacity: _fadeScale,
        child: ScaleTransition(
          scale: _fadeScale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.food.labelColor.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.food.labelColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.food.confidencePercent}%',
                  style: TextStyle(
                    color: widget.food.labelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
