import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/timer_state.dart';

class FocusTimerNotifier extends Notifier<FocusTimerState> {
  Timer? _ticker;

  @override
  FocusTimerState build() {
    final prefs = ref.watch(preferencesServiceProvider);
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return FocusTimerState(
      totalSeconds: prefs.focusMinutes * 60,
      remainingSeconds: prefs.focusMinutes * 60,
    );
  }

  void setTask(TaskModel task) {
    final prefs = ref.read(preferencesServiceProvider);
    int durationSec;
    if (task.timerType == TimerType.pomodoro) {
      durationSec = prefs.focusMinutes * 60;
    } else if (task.timerType == TimerType.custom) {
      durationSec = task.durationMinutes * 60;
    } else {
      durationSec = prefs.focusMinutes * 60;
    }

    state = FocusTimerState(
      currentTask: task,
      mode: TimerMode.focus,
      status: TimerStatus.idle,
      totalSeconds: durationSec,
      remainingSeconds: durationSec,
    );
  }

  void startSession({TaskModel? task, int? customMinutes, TimerMode mode = TimerMode.focus}) {
    _ticker?.cancel();
    final prefs = ref.read(preferencesServiceProvider);
    final targetMinutes = customMinutes ??
        (mode == TimerMode.focus ? prefs.focusMinutes : prefs.breakMinutes);
    final totalSec = targetMinutes * 60;

    state = state.copyWith(
      currentTask: task ?? state.currentTask,
      mode: mode,
      status: TimerStatus.running,
      totalSeconds: totalSec,
      remainingSeconds: totalSec,
    );

    HapticsHelper.medium();
    _startTicker();
  }

  void pause() {
    if (!state.status.isRunning) return;
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
    HapticsHelper.light();
  }

  void resume() {
    if (state.status.isRunning) return;
    state = state.copyWith(status: TimerStatus.running);
    HapticsHelper.light();
    _startTicker();
  }

  void reset() {
    _ticker?.cancel();
    state = state.copyWith(
      status: TimerStatus.idle,
      remainingSeconds: state.totalSeconds,
    );
    HapticsHelper.selection();
  }

  void finish() {
    _ticker?.cancel();
    state = state.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
    );
    HapticsHelper.success();
    NotificationService().showTimerCompleteNotification(
      taskTitle: state.currentTask?.title ?? 'Session',
      isBreak: state.mode == TimerMode.restBreak,
    );
  }

  void startBreak([int? breakMinutes]) {
    final prefs = ref.read(preferencesServiceProvider);
    final mins = breakMinutes ?? prefs.breakMinutes;
    final totalSec = mins * 60;
    _ticker?.cancel();
    state = state.copyWith(
      mode: TimerMode.restBreak,
      status: TimerStatus.running,
      totalSeconds: totalSec,
      remainingSeconds: totalSec,
    );
    HapticsHelper.medium();
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        finish();
      }
    });
  }
}

final focusTimerProvider =
    NotifierProvider<FocusTimerNotifier, FocusTimerState>(FocusTimerNotifier.new);
