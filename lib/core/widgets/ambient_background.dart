import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Stack(
      children: [
        // Base background color
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          color: theme.background,
        ),
        // Subtle ambient radial glow orb at top right
        Positioned(
          top: -120,
          right: -80,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.glowColor.withValues(alpha: theme.isDark ? 0.15 : 0.08),
                    theme.glowColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Subtle ambient radial glow orb at bottom left
        Positioned(
          bottom: -100,
          left: -60,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.secondary.withValues(alpha: theme.isDark ? 0.08 : 0.05),
                    theme.secondary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}
