import 'package:flutter/material.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../data/models/task_model.dart';

class TimelineTaskTile extends StatelessWidget {
  final TaskModel task;
  final bool isFirst;
  final bool isLast;
  final bool isCurrent;
  final VoidCallback onTap;

  const TimelineTaskTile({
    super.key,
    required this.task,
    this.isFirst = false,
    this.isLast = false,
    this.isCurrent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final category = TaskCategory.fromId(task.category);
    final isDone = task.isCompleted;
    final isSkipped = task.isSkipped;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time Column (Fixed Width)
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  TimeUtils.formatTimeOfDay(task.startTime),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                    color: isCurrent
                        ? theme.primary
                        : (isDone ? theme.textMuted : theme.textSecondary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Vertical Line + Dot Column
          SizedBox(
            width: 16,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Connecting line
                Positioned(
                  top: isFirst ? 20 : 0,
                  bottom: isLast ? 20 : 0,
                  child: Container(
                    width: 2,
                    color: isDone
                        ? theme.success.withValues(alpha: 0.5)
                        : theme.border.withValues(alpha: 0.5),
                  ),
                ),
                // Timeline Dot
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isCurrent ? 16 : 12,
                    height: isCurrent ? 16 : 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? theme.success
                          : (isCurrent
                              ? theme.primary
                              : (isSkipped ? theme.textMuted : theme.surfaceAccent)),
                      border: Border.all(
                        color: isCurrent
                            ? theme.primary
                            : (isDone ? theme.success : theme.border),
                        width: isCurrent ? 2.5 : 1.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: theme.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                    child: isDone
                        ? const Center(
                            child: Icon(Icons.check, size: 7, color: Colors.white),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Task Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: BounceTappable(
                onTap: onTap,
                scaleLower: 0.98,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? theme.surfaceCard
                        : (isDone
                            ? theme.surfaceCard.withValues(alpha: 0.4)
                            : theme.surfaceCard),
                    borderRadius: BorderRadius.circular(theme.cardRadius * 0.75),
                    border: Border.all(
                      color: isCurrent
                          ? theme.primary.withValues(alpha: 0.8)
                          : theme.border.withValues(alpha: isDone ? 0.3 : 0.6),
                      width: isCurrent ? 1.5 : 1.0,
                    ),
                    boxShadow: isCurrent ? theme.glowShadow : theme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      // Emoji
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: category.accentColor.withValues(
                            alpha: theme.isDark ? 0.18 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            task.emoji,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: isDone ? theme.textMuted : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: theme.titleMedium.copyWith(
                                      fontWeight:
                                          isCurrent ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 14.5,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDone
                                          ? theme.textMuted
                                          : theme.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isCurrent) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'NOW',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: TimeUtils.formatDuration(task.durationMinutes),
                                    style: theme.bodyMedium.copyWith(
                                      fontSize: 11.5,
                                      color: theme.textMuted,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  •  ',
                                    style: TextStyle(
                                      color: theme.textMuted,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: category.name,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: category.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.textMuted,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
