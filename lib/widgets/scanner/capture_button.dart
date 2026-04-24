import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Large animated capture button with shutter animation
class CaptureButton extends StatefulWidget {
  final VoidCallback onCapture;

  const CaptureButton({super.key, required this.onCapture});

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
    _ctrl.forward();
    HapticFeedback.mediumImpact();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _ctrl.reverse();
    widget.onCapture();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF10B981,
                ).withValues(alpha: _isPressed ? 0.6 : 0.3),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPressed ? const Color(0xFF10B981) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
