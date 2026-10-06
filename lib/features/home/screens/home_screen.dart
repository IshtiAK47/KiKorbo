import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/screens/settings_screen.dart';
import '../../task/screens/add_edit_task_sheet.dart';
import '../../task/screens/task_detail_sheet.dart';
import '../../timer/controllers/timer_controller.dart';
import '../../timer/screens/focus_timer_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/current_task_card.dart';
import '../widgets/day_progress_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/next_task_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final currentTask = ref.watch(currentTaskProvider);
    final nextTask = ref.watch(nextTaskProvider);
    final dayState = ref.watch(dayStateProvider);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(tasksProvider.notifier).loadDate(today);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Date, KiKorbo? title, settings icon
                HomeHeader(
                  onOpenSettings: () {
                    SettingsScreen.open(context);
                  },
                ),
                const SizedBox(height: 12),
                // Today's Flow dot timeline indicator
                if (todayTasks.isNotEmpty) ...[
                  DayProgressBar(
                    tasks: todayTasks,
                    currentTask: currentTask,
                    onTaskTap: (task) {
                      TaskDetailSheet.show(context, task);
                    },
                  ),
                ],
                const SizedBox(height: 8),
                // Hero: Current Task Card (Dominates the screen)
                CurrentTaskCard(
                  currentTask: currentTask,
                  dayState: dayState,
                  onStartTimer: () {
                    if (currentTask != null) {
                      ref.read(focusTimerProvider.notifier).setTask(currentTask);
                      ref.read(focusTimerProvider.notifier).startSession(task: currentTask);
                    } else {
                      ref.read(focusTimerProvider.notifier).startSession(customMinutes: 25);
                    }
                    FocusTimerScreen.open(context);
                  },
                  onCompleteTask: () async {
                    if (currentTask != null) {
                      await ref
                          .read(tasksProvider.notifier)
                          .completeTask(currentTask);
                    }
                  },
                  onCardTap: () {
                    if (currentTask != null) {
                      TaskDetailSheet.show(context, currentTask);
                    }
                  },
                  onAddTask: () {
                    AddEditTaskSheet.show(context, initialDate: today);
                  },
                ),
                const SizedBox(height: 8),
                // UP NEXT Preview Card
                if (nextTask != null) ...[
                  NextTaskCard(
                    nextTask: nextTask,
                    onTap: () {
                      TaskDetailSheet.show(context, nextTask);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
