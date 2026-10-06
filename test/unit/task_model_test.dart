import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kikorbo/data/models/task_model.dart';

void main() {
  group('TaskModel Unit Tests', () {
    final today = DateTime(2026, 10, 7);

    test('Task creation and fields check', () {
      final task = TaskModel(
        id: 1,
        title: 'Study DBMS',
        date: today,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        durationMinutes: 50,
        category: 'study',
        emoji: '📚',
        timerType: TimerType.pomodoro,
      );

      expect(task.id, 1);
      expect(task.title, 'Study DBMS');
      expect(task.category, 'study');
      expect(task.durationMinutes, 50);
      expect(task.timerType, TimerType.pomodoro);
      expect(task.isCompleted, false);
      expect(task.isSkipped, false);

      expect(task.startDateTime, DateTime(2026, 10, 7, 9, 0));
      expect(task.endDateTime, DateTime(2026, 10, 7, 9, 50));
    });

    test('Task copyWith updates fields correctly', () {
      final task = TaskModel(
        id: 1,
        title: 'Original Title',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 30,
      );

      final completed = task.copyWith(isCompleted: true);
      expect(completed.isCompleted, true);
      expect(completed.id, 1);
      expect(completed.title, 'Original Title');

      final renamed = task.copyWith(title: 'Updated Title');
      expect(renamed.title, 'Updated Title');
    });

    test('SQLite serialization toMap and fromMap', () {
      final task = TaskModel(
        id: 42,
        title: 'Practice Python',
        date: today,
        startTime: const TimeOfDay(hour: 14, minute: 30),
        durationMinutes: 45,
        category: 'study',
        emoji: '🐍',
        timerType: TimerType.custom,
        isCompleted: true,
        isSkipped: false,
      );

      final map = task.toMap();
      expect(map['id'], 42);
      expect(map['title'], 'Practice Python');
      expect(map['date'], '2026-10-07');
      expect(map['start_hour'], 14);
      expect(map['start_minute'], 30);
      expect(map['duration_minutes'], 45);
      expect(map['category'], 'study');
      expect(map['emoji'], '🐍');
      expect(map['timer_type'], 'custom');
      expect(map['is_completed'], 1);
      expect(map['is_skipped'], 0);

      final fromMapTask = TaskModel.fromMap(map);
      expect(fromMapTask.id, task.id);
      expect(fromMapTask.title, task.title);
      expect(fromMapTask.date, task.date);
      expect(fromMapTask.startTime.hour, task.startTime.hour);
      expect(fromMapTask.startTime.minute, task.startTime.minute);
      expect(fromMapTask.durationMinutes, task.durationMinutes);
      expect(fromMapTask.isCompleted, true);
      expect(fromMapTask.isSkipped, false);
      expect(fromMapTask.timerType, TimerType.custom);
    });

    test('Task overlap detection accurately detects conflicts', () {
      final task1 = TaskModel(
        title: 'DBMS',
        date: today,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        durationMinutes: 60, // 09:00 - 10:00
      );

      final overlappingTask = TaskModel(
        title: 'Python',
        date: today,
        startTime: const TimeOfDay(hour: 9, minute: 30),
        durationMinutes: 60, // 09:30 - 10:30
      );

      final nonOverlappingTask = TaskModel(
        title: 'Lunch',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 30, // 10:00 - 10:30 (starts right when task1 ends)
      );

      final separateDayTask = TaskModel(
        title: 'DBMS Next Day',
        date: DateTime(2026, 10, 8),
        startTime: const TimeOfDay(hour: 9, minute: 15),
        durationMinutes: 30,
      );

      expect(task1.overlapsWith(overlappingTask), isTrue);
      expect(overlappingTask.overlapsWith(task1), isTrue);
      expect(task1.overlapsWith(nonOverlappingTask), isFalse);
      expect(task1.overlapsWith(separateDayTask), isFalse);
    });
  });
}
