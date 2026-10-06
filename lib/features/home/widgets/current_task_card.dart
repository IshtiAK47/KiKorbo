import 'package:flutter/material.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../data/models/task_model.dart';
import '../controllers/home_controller.dart';

class CurrentTaskCard extends StatefulWidget {
  final TaskModel? currentTask;
  final DayState dayState;
  final VoidCallback onStartTimer;
  final VoidCallback onCompleteTask;
  final VoidCallback onCardTap;
  final VoidCallback onAddTask;

  const CurrentTaskCard({
    super.key,
    required this.currentTask,
    required this.dayState,
    required this.onStartTimer,
    required this.onCompleteTask,
    required this.onCardTap,
    required this.onAddTask,
  });

  @override
  State<CurrentTaskCard> createState() => _CurrentTaskCardState();
}

class _CurrentTaskCardState extends State<CurrentTaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _buildStateContent(context, theme),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, AppThemeData theme) {
    switch (widget.dayState) {
      case DayState.hasCurrent:
        return _buildActiveTaskCard(theme);
      case DayState.betweenTasks:
        return _buildBetweenTasksCard(theme);
      case DayState.dayFinished:
        return _buildDayFinishedCard(theme);
      case DayState.empty:
        return _buildEmptyStateCard(theme);
    }
  }

  Widget _buildActiveTaskCard(AppThemeData theme) {
    final task = widget.currentTask!;
    final category = TaskCategory.fromId(task.category);

    return BounceTappable(
      key: ValueKey('active_${task.id}'),
      onTap: widget.onCardTap,
      scaleLower: 0.98,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: theme.surfaceCard,
          borderRadius: BorderRadius.circular(theme.cardRadius),
          border: Border.all(
            color: theme.border,
            width: 1.5,
          ),
          boxShadow: [
            ...theme.cardShadow,
            ...theme.glowShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: NOW badge + Category badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withValues(alpha: 0.3 * _pulseAnimation.value),
                          blurRadius: 12 * _pulseAnimation.value,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'NOW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: category.accentColor.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: category.accentColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: category.accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Large Emoji + Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.surfaceAccent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      task.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.headingMedium.copyWith(
                          fontSize: 22.0,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        TimeUtils.formatTimeRange(task.startTime, task.durationMinutes),
                        style: theme.titleMedium.copyWith(
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: BounceTappable(
                    onTap: widget.onStartTimer,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primary,
                            theme.primaryVariant,
                          ],
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
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'START FOCUS',
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
                ),
                const SizedBox(width: 12),
                BounceTappable(
                  onTap: () {
                    HapticsHelper.success();
                    widget.onCompleteTask();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: theme.surfaceAccent,
                      borderRadius: BorderRadius.circular(theme.buttonRadius),
                      border: Border.all(
                        color: theme.border,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: theme.success,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetweenTasksCard(AppThemeData theme) {
    return Container(
      key: const ValueKey('between_tasks'),
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.surfaceCard,
        borderRadius: BorderRadius.circular(theme.cardRadius),
        border: Border.all(
          color: theme.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: theme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.secondary.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'FREE TIME',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: theme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing planned right now.',
            style: theme.headingMedium.copyWith(fontSize: 22.0),
          ),
          const SizedBox(height: 6),
          Text(
            'You are free. Take a breather or prepare for what is next.',
            style: theme.bodyLarge.copyWith(color: theme.textSecondary),
          ),
          const SizedBox(height: 18),
          BounceTappable(
            onTap: widget.onStartTimer,
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.surfaceAccent,
                borderRadius: BorderRadius.circular(theme.buttonRadius),
                border: Border.all(
                  color: theme.border.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: theme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Focus Session',
                    style: TextStyle(
                      fontSize: 13.0,
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
    );
  }

  Widget _buildDayFinishedCard(AppThemeData theme) {
    return Container(
      key: const ValueKey('day_finished'),
      width: double.infinity,
      padding: const EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        color: theme.surfaceCard,
        borderRadius: BorderRadius.circular(theme.cardRadius),
        border: Border.all(
          color: theme.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: theme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.success.withValues(alpha: theme.isDark ? 0.2 : 0.12),
            ),
            child: Center(
              child: Icon(
                Icons.check_circle_rounded,
                color: theme.success,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "You're done for today.",
            style: theme.headingMedium.copyWith(fontSize: 22.0),
          ),
          const SizedBox(height: 6),
          Text(
            "All scheduled tasks completed. Nice work!",
            style: theme.bodyLarge.copyWith(color: theme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(AppThemeData theme) {
    return Container(
      key: const ValueKey('empty_schedule'),
      width: double.infinity,
      padding: const EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        color: theme.surfaceCard,
        borderRadius: BorderRadius.circular(theme.cardRadius),
        border: Border.all(
          color: theme.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: theme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nothing planned yet.',
            style: theme.headingMedium.copyWith(fontSize: 22.0),
          ),
          const SizedBox(height: 6),
          Text(
            'What do you want to do today?',
            style: theme.bodyLarge.copyWith(color: theme.textSecondary),
          ),
          const SizedBox(height: 20),
          BounceTappable(
            onTap: widget.onAddTask,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: BorderRadius.circular(theme.buttonRadius),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ADD FIRST TASK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Colors.white,
                    ),
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
