import 'task_model.dart';

enum TimerMode {
  focus,
  restBreak;

  String get label {
    switch (this) {
      case TimerMode.focus:
        return 'FOCUS';
      case TimerMode.restBreak:
        return 'SHORT BREAK';
    }
  }
}

enum TimerStatus {
  idle,
  running,
  paused,
  completed;

  bool get isRunning => this == TimerStatus.running;
  bool get isPaused => this == TimerStatus.paused;
  bool get isCompleted => this == TimerStatus.completed;
  bool get isIdle => this == TimerStatus.idle;
}

class FocusTimerState {
  final TaskModel? currentTask;
  final TimerMode mode;
  final TimerStatus status;
  final int totalSeconds;
  final int remainingSeconds;

  const FocusTimerState({
    this.currentTask,
    this.mode = TimerMode.focus,
    this.status = TimerStatus.idle,
    this.totalSeconds = 25 * 60,
    this.remainingSeconds = 25 * 60,
  });

  double get progress {
    if (totalSeconds <= 0) return 0.0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  FocusTimerState copyWith({
    TaskModel? currentTask,
    TimerMode? mode,
    TimerStatus? status,
    int? totalSeconds,
    int? remainingSeconds,
    bool clearTask = false,
  }) {
    return FocusTimerState(
      currentTask: clearTask ? null : (currentTask ?? this.currentTask),
      mode: mode ?? this.mode,
      status: status ?? this.status,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}
