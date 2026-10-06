import 'package:flutter/material.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../data/models/task_model.dart';

class NextTaskCard extends StatelessWidget {
  final TaskModel nextTask;
  final VoidCallback onTap;

  const NextTaskCard({
    super.key,
    required this.nextTask,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final category = TaskCategory.fromId(nextTask.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'UP NEXT',
                style: theme.labelSmall.copyWith(
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BounceTappable(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.surfaceCard,
                borderRadius: BorderRadius.circular(theme.cardRadius * 0.8),
                border: Border.all(
                  color: theme.border.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: theme.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: category.accentColor.withValues(alpha: theme.isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: category.accentColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        nextTask.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextTask.title,
                          style: theme.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 13,
                              color: theme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              TimeUtils.formatTimeOfDay(nextTask.startTime),
                              style: theme.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TextStyle(color: theme.textMuted),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              TimeUtils.formatDuration(nextTask.durationMinutes),
                              style: theme.bodyMedium.copyWith(
                                color: theme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.textMuted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
