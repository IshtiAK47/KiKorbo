import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const HomeHeader({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TimeUtils.formatDayOfWeek(now).toUpperCase(),
                  style: theme.labelSmall.copyWith(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  TimeUtils.formatDateHeader(now).split('\n').last,
                  style: theme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: theme.headingLarge,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'v${AppConstants.appVersion}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Here's what you're doing now.",
                  style: theme.bodyMedium.copyWith(
                    color: theme.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          BounceTappable(
            onTap: onOpenSettings,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.border.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: theme.cardShadow,
              ),
              child: Icon(
                Icons.tune_rounded,
                color: theme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
