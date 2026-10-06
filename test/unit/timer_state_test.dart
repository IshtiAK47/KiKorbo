import 'package:flutter_test/flutter_test.dart';
import 'package:kikorbo/data/models/timer_state.dart';

void main() {
  group('FocusTimerState Tests', () {
    test('Formatted time outputs correct MM:SS', () {
      const state1 = FocusTimerState(
        totalSeconds: 25 * 60,
        remainingSeconds: 25 * 60,
      );
      expect(state1.formattedTime, '25:00');

      const state2 = FocusTimerState(
        totalSeconds: 25 * 60,
        remainingSeconds: 24 * 60 + 37,
      );
      expect(state2.formattedTime, '24:37');

      const state3 = FocusTimerState(
        totalSeconds: 25 * 60,
        remainingSeconds: 9,
      );
      expect(state3.formattedTime, '00:09');

      const state4 = FocusTimerState(
        totalSeconds: 25 * 60,
        remainingSeconds: 0,
      );
      expect(state4.formattedTime, '00:00');
    });

    test('Progress calculation is accurate', () {
      const stateStart = FocusTimerState(
        totalSeconds: 100,
        remainingSeconds: 100,
      );
      expect(stateStart.progress, 0.0);

      const stateHalf = FocusTimerState(
        totalSeconds: 100,
        remainingSeconds: 50,
      );
      expect(stateHalf.progress, 0.5);

      const stateEnd = FocusTimerState(
        totalSeconds: 100,
        remainingSeconds: 0,
      );
      expect(stateEnd.progress, 1.0);
    });

    test('Timer status booleans work as expected', () {
      const idle = FocusTimerState(status: TimerStatus.idle);
      expect(idle.status.isIdle, isTrue);
      expect(idle.status.isRunning, isFalse);

      const running = FocusTimerState(status: TimerStatus.running);
      expect(running.status.isRunning, isTrue);

      const paused = FocusTimerState(status: TimerStatus.paused);
      expect(paused.status.isPaused, isTrue);

      const completed = FocusTimerState(status: TimerStatus.completed);
      expect(completed.status.isCompleted, isTrue);
    });
  });
}
