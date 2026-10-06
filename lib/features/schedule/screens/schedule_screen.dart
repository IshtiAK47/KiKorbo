import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../home/controllers/home_controller.dart';
import '../../task/screens/add_edit_task_sheet.dart';
import '../../task/screens/task_detail_sheet.dart';
import '../widgets/date_selector_strip.dart';
import '../widgets/timeline_task_tile.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final selectedDate = ref.watch(selectedScheduleDateProvider);
    final tasks = ref.watch(tasksForDateProvider(selectedDate));
    final now = DateTime.now();
    final isSelectedToday = TimeUtils.isToday(selectedDate);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DAILY SCHEDULE',
                          style: theme.labelSmall.copyWith(letterSpacing: 2.0),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isSelectedToday
                              ? 'Today (${TimeUtils.formatDayOfMonth(selectedDate)} ${TimeUtils.formatDayOfWeek(selectedDate)})'
                              : TimeUtils.formatShortDate(selectedDate),
                          style: theme.headingMedium.copyWith(fontSize: 22.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!isSelectedToday) ...[
                    BounceTappable(
                      onTap: () {
                        final today = DateTime(now.year, now.month, now.day);
                        ref.read(selectedScheduleDateProvider.notifier).setDate(today);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.primary.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          'Jump to Today',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: theme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Date Selector Strip
            DateSelectorStrip(
              selectedDate: selectedDate,
              onDateSelected: (newDate) {
                ref.read(selectedScheduleDateProvider.notifier).setDate(newDate);
              },
            ),
            const SizedBox(height: 12),
            // Timeline Content
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            size: 48,
                            color: theme.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No activities scheduled',
                            style: theme.titleMedium.copyWith(
                              color: theme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSelectedToday
                                ? 'Your day is completely clear.'
                                : 'Nothing planned for ${TimeUtils.formatShortDate(selectedDate)}.',
                            style: theme.bodyMedium.copyWith(color: theme.textMuted),
                          ),
                          const SizedBox(height: 20),
                          BounceTappable(
                            onTap: () {
                              AddEditTaskSheet.show(
                                context,
                                initialDate: selectedDate,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: theme.surfaceCard,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: theme.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add, size: 18, color: theme.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Plan an activity',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(tasksProvider.notifier)
                            .loadDate(selectedDate);
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final isCurrent = isSelectedToday && task.isCurrent(now);

                          return TimelineTaskTile(
                            task: task,
                            isFirst: index == 0,
                            isLast: index == tasks.length - 1,
                            isCurrent: isCurrent,
                            onTap: () {
                              TaskDetailSheet.show(context, task);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
