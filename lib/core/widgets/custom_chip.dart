import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import 'bounce_tappable.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  const CustomChip({
    super.key,
    required this.label,
    this.emoji,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final activeColor = accentColor ?? theme.primary;

    return BounceTappable(
      onTap: onTap,
      scaleLower: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: theme.isDark ? 0.22 : 0.14)
              : theme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? activeColor.withValues(alpha: 0.7)
                : theme.border.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(
                emoji!,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? activeColor : theme.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? (theme.isDark ? Colors.white : activeColor) : theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
