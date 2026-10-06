import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../data/models/task_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../timer/controllers/timer_controller.dart';
import '../../timer/screens/focus_timer_screen.dart';
import 'add_edit_task_sheet.dart';

class TaskDetailSheet extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailSheet({
    super.key,
    required this.task,
  });

  static Future<void> show(BuildContext context, TaskModel task) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(task: task),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final category = TaskCategory.fromId(task.category);
    final now = DateTime.now();

    String statusLabel = 'Upcoming';
    Color statusColor = theme.secondary;

    if (task.isCompleted) {
      statusLabel = 'Completed';
      statusColor = theme.success;
    } else if (task.isSkipped) {
      statusLabel = 'Skipped';
      statusColor = theme.textMuted;
    } else if (task.isCurrent(now)) {
      statusLabel = 'In Progress (NOW)';
      statusColor = theme.primary;
    } else if (task.isPast(now)) {
      statusLabel = 'Past';
      statusColor = theme.textMuted;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: theme.border, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Category & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: category.accentColor.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: category.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(task.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: category.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: theme.isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            task.title,
            style: theme.headingMedium.copyWith(fontSize: 24.0),
          ),
          const SizedBox(height: 12),
          // Time range and duration
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.border.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 20, color: theme.primary),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TIME', style: theme.labelSmall.copyWith(fontSize: 9.0)),
                          const SizedBox(height: 2),
                          Text(
                            TimeUtils.formatTimeRange(task.startTime, task.durationMinutes),
                            style: theme.titleMedium.copyWith(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 36, color: theme.divider),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.timelapse_rounded, size: 20, color: theme.secondary),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DURATION', style: theme.labelSmall.copyWith(fontSize: 9.0)),
                          const SizedBox(height: 2),
                          Text(
                            TimeUtils.formatDuration(task.durationMinutes),
                            style: theme.titleMedium.copyWith(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Primary Action: Start Timer if not completed
          if (!task.isCompleted && !task.isSkipped) ...[
            BounceTappable(
              onTap: () {
                Navigator.of(context).pop();
                ref.read(focusTimerProvider.notifier).setTask(task);
                ref.read(focusTimerProvider.notifier).startSession(task: task);
                FocusTimerScreen.open(context);
              },
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.primaryVariant],
                  ),
                  borderRadius: BorderRadius.circular(theme.buttonRadius),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'START FOCUS TIMER',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Action Buttons: Complete / Skip / Edit / Delete
          Row(
            children: [
              // Complete / Reopen
              Expanded(
                child: BounceTappable(
                  onTap: () async {
                    Navigator.of(context).pop();
                    HapticsHelper.success();
                    final notifier = ref.read(tasksProvider.notifier);
                    if (task.isCompleted) {
                      await notifier.uncompleteTask(task);
                    } else {
                      await notifier.completeTask(task);
                    }
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? theme.surfaceAccent
                          : theme.success.withValues(alpha: theme.isDark ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(theme.buttonRadius),
                      border: Border.all(
                        color: task.isCompleted
                            ? theme.border
                            : theme.success.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        task.isCompleted ? 'Mark Pending' : '✓ Complete',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: task.isCompleted ? theme.textSecondary : theme.success,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Skip
              if (!task.isCompleted) ...[
                Expanded(
                  child: BounceTappable(
                    onTap: () async {
                      Navigator.of(context).pop();
                      HapticsHelper.light();
                      await ref
                          .read(tasksProvider.notifier)
                          .skipTask(task);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.surfaceAccent,
                        borderRadius: BorderRadius.circular(theme.buttonRadius),
                        border: Border.all(color: theme.border),
                      ),
                      child: Center(
                        child: Text(
                          task.isSkipped ? 'Unskip' : 'Skip',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              // Edit
              BounceTappable(
                onTap: () {
                  Navigator.of(context).pop();
                  AddEditTaskSheet.show(context, taskToEdit: task);
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: theme.surfaceAccent,
                    borderRadius: BorderRadius.circular(theme.buttonRadius),
                    border: Border.all(color: theme.border),
                  ),
                  child: Center(
                    child: Icon(Icons.edit_outlined, size: 20, color: theme.textPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Delete
              BounceTappable(
                onTap: () {
                  _confirmDelete(context, ref);
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: theme.error.withValues(alpha: theme.isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(theme.buttonRadius),
                    border: Border.all(color: theme.error.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Icon(Icons.delete_outline_rounded, size: 20, color: theme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.border),
        ),
        title: Text('Delete Task?', style: theme.titleLarge),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: theme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('Cancel', style: TextStyle(color: theme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop(); // close dialog
              Navigator.of(context).pop(); // close bottom sheet
              HapticsHelper.light();
              await ref.read(tasksProvider.notifier).deleteTask(task);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
