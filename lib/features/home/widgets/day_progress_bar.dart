import 'package:flutter/material.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../data/models/task_model.dart';

class DayProgressBar extends StatelessWidget {
  final List<TaskModel> tasks;
  final TaskModel? currentTask;
  final ValueChanged<TaskModel>? onTaskTap;

  const DayProgressBar({
    super.key,
    required this.tasks,
    this.currentTask,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final theme = context.appTheme;
    final now = DateTime.now();

    final completedCount = tasks.where((t) => t.isCompleted).length;
    final totalCount = tasks.length;
    final percent = (completedCount / totalCount * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.surfaceCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.border.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TODAY'S FLOW",
                  style: theme.labelSmall.copyWith(
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '$completedCount of $totalCount completed ($percent%)',
                  style: theme.bodyMedium.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Horizontal scrollable dot timeline
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: tasks.length,
                separatorBuilder: (context, index) {
                  final isDone = tasks[index].isCompleted;
                  return Center(
                    child: Container(
                      width: 24,
                      height: 2,
                      decoration: BoxDecoration(
                        color: isDone
                            ? theme.success.withValues(alpha: 0.7)
                            : theme.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final isCurrent = currentTask?.id == task.id || task.isCurrent(now);
                  final isCompleted = task.isCompleted;
                  final isSkipped = task.isSkipped;

                  Color dotColor;
                  Widget iconContent;

                  if (isCompleted) {
                    dotColor = theme.success;
                    iconContent = const Icon(Icons.check, size: 12, color: Colors.white);
                  } else if (isCurrent) {
                    dotColor = theme.primary;
                    iconContent = Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    );
                  } else if (isSkipped) {
                    dotColor = theme.textMuted;
                    iconContent = const Icon(Icons.close, size: 10, color: Colors.white);
                  } else {
                    dotColor = theme.surfaceAccent;
                    iconContent = Text(
                      task.emoji,
                      style: const TextStyle(fontSize: 10),
                    );
                  }

                  return GestureDetector(
                    onTap: () => onTaskTap?.call(task),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isCurrent ? 26 : 22,
                          height: isCurrent ? 26 : 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: theme.primary.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                            border: Border.all(
                              color: isCurrent
                                  ? theme.primary
                                  : (isCompleted ? theme.success : theme.border),
                              width: isCurrent ? 2 : 1,
                            ),
                          ),
                          child: Center(child: iconContent),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          TimeUtils.formatTimeOfDay(task.startTime),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCurrent
                                ? theme.primary
                                : (isCompleted ? theme.textMuted : theme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
