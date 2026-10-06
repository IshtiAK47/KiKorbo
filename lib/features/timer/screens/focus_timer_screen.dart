import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../core/widgets/custom_chip.dart';
import '../../../data/models/timer_state.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/timer_controller.dart';
import '../widgets/timer_ring_painter.dart';

class FocusTimerScreen extends ConsumerStatefulWidget {
  const FocusTimerScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FocusTimerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.08);
          const end = Offset.zero;
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(begin: begin, end: end).animate(curve),
            child: FadeTransition(opacity: curve, child: child),
          );
        },
      ),
    );
  }

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  final List<int> _focusPresets = [15, 25, 40, 50];

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _showCompletionDialog(FocusTimerState timerState) {
    final theme = context.appTheme;
    final isBreak = timerState.mode == TimerMode.restBreak;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: theme.border, width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.success.withValues(alpha: theme.isDark ? 0.2 : 0.12),
              ),
              child: Center(
                child: Icon(Icons.check_rounded, color: theme.success, size: 32),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isBreak ? 'Break Complete!' : 'Session Complete!',
              style: theme.headingMedium.copyWith(fontSize: 22.0),
            ),
            const SizedBox(height: 6),
            Text(
              isBreak
                ? 'Ready to get back to your tasks?'
                : '${timerState.currentTask?.title ?? "Focus"} session finished.',
              textAlign: TextAlign.center,
              style: theme.bodyLarge.copyWith(color: theme.textSecondary),
            ),
            const SizedBox(height: 24),
            if (!isBreak) ...[
              BounceTappable(
                onTap: () {
                  Navigator.of(ctx).pop();
                  ref.read(focusTimerProvider.notifier).startBreak(5);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.secondary, theme.primary],
                    ),
                    borderRadius: BorderRadius.circular(theme.buttonRadius),
                  ),
                  child: const Center(
                    child: Text(
                      'START 5 MIN BREAK',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            BounceTappable(
              onTap: () async {
                Navigator.of(ctx).pop();
                final task = timerState.currentTask;
                if (task != null) {
                  await ref
                      .read(tasksProvider.notifier)
                      .completeTask(task);
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.surfaceAccent,
                  borderRadius: BorderRadius.circular(theme.buttonRadius),
                  border: Border.all(color: theme.border),
                ),
                child: Center(
                  child: Text(
                    !isBreak && timerState.currentTask != null
                        ? 'MARK TASK DONE & EXIT'
                        : 'FINISH & EXIT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final timerState = ref.watch(focusTimerProvider);
    final timerNotifier = ref.read(focusTimerProvider.notifier);
    final task = timerState.currentTask;
    final category = TaskCategory.fromId(task?.category);

    // Listen for completion
    ref.listen<FocusTimerState>(focusTimerProvider, (prev, next) {
      if (prev?.status != TimerStatus.completed &&
          next.status == TimerStatus.completed) {
        _showCompletionDialog(next);
      }
    });

    final isFocusMode = timerState.mode == TimerMode.focus;
    final ringColor = isFocusMode ? theme.primary : theme.secondary;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
                  ),
                  // Mode Toggle
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: theme.surfaceCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.border.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildModeTab(
                          label: 'FOCUS',
                          isSelected: isFocusMode,
                          theme: theme,
                          onTap: () {
                            if (!isFocusMode) {
                              timerNotifier.startSession(mode: TimerMode.focus);
                            }
                          },
                        ),
                        _buildModeTab(
                          label: 'BREAK',
                          isSelected: !isFocusMode,
                          theme: theme,
                          onTap: () {
                            if (isFocusMode) {
                              timerNotifier.startBreak();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // Balance spacing
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Task Title & Category Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  if (task != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(task.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
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
                    const SizedBox(height: 6),
                    Text(
                      task.title,
                      textAlign: TextAlign.center,
                      style: theme.headingMedium.copyWith(fontSize: 22.0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Text(
                      isFocusMode ? 'Focus Session' : 'Short Break',
                      style: theme.headingMedium.copyWith(fontSize: 22.0),
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            // Center Circular Timer
            Center(
              child: AnimatedBuilder(
                animation: _breathingAnimation,
                builder: (context, child) {
                  final scale = timerState.status.isRunning
                      ? _breathingAnimation.value
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(280, 280),
                        painter: TimerRingPainter(
                          progress: timerState.progress,
                          ringColor: ringColor,
                          trackColor: theme.surfaceCard,
                          glowColor: theme.glowColor,
                          strokeWidth: 12.0,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timerState.formattedTime,
                            style: theme.timerDigits.copyWith(
                              color: theme.textPrimary,
                              fontSize: 56,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ringColor.withValues(
                                alpha: theme.isDark ? 0.2 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              timerState.mode.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.6,
                                color: ringColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Presets row (only available when paused or idle)
            if (timerState.status.isIdle || timerState.status.isPaused) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _focusPresets.map((mins) {
                    final isCurrentTotal = (timerState.totalSeconds ~/ 60) == mins;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomChip(
                        label: '$mins m',
                        isSelected: isCurrentTotal,
                        onTap: () {
                          HapticsHelper.selection();
                          timerNotifier.startSession(
                            customMinutes: mins,
                            mode: timerState.mode,
                          );
                          timerNotifier.pause();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset Button
                  BounceTappable(
                    onTap: timerNotifier.reset,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: theme.surfaceCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.border.withValues(alpha: 0.6)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.replay_rounded,
                          color: theme.textSecondary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Primary Play / Pause Button
                  BounceTappable(
                    onTap: () {
                      if (timerState.status.isRunning) {
                        timerNotifier.pause();
                      } else {
                        timerNotifier.resume();
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.primary, theme.primaryVariant],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          timerState.status.isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Finish Button
                  BounceTappable(
                    onTap: timerNotifier.finish,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: theme.surfaceCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.border.withValues(alpha: 0.6)),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.stop_rounded,
                          color: theme.error,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab({
    required String label,
    required bool isSelected,
    required AppThemeData theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: isSelected ? Colors.white : theme.textSecondary,
          ),
        ),
      ),
    );
  }
}
