import 'package:flutter/material.dart';
import '../utils/haptics_helper.dart';

class BounceTappable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleLower;
  final Duration duration;
  final bool enableHaptic;

  const BounceTappable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleLower = 0.96,
    this.duration = const Duration(milliseconds: 120),
    this.enableHaptic = true,
  });

  @override
  State<BounceTappable> createState() => _BounceTappableState();
}

class _BounceTappableState extends State<BounceTappable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
      value: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: widget.scaleLower,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    _controller.reverse();
    if (widget.enableHaptic) {
      HapticsHelper.light();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    _controller.forward();
  }

  void _onTapCancel() {
    if (widget.onTap == null && widget.onLongPress == null) return;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
