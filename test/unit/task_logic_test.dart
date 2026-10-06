import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kikorbo/data/models/task_model.dart';

void main() {
  group('Current and Next Task Resolution Tests', () {
    final testDate = DateTime(2026, 10, 7);

    final dbmsTask = TaskModel(
      id: 1,
      title: 'DBMS',
      date: testDate,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      durationMinutes: 60, // 09:00 - 10:00
    );

    final pythonTask = TaskModel(
      id: 2,
      title: 'Python',
      date: testDate,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 30, // 10:00 - 10:30
    );

    final animeTask = TaskModel(
      id: 3,
      title: 'Anime',
      date: testDate,
      startTime: const TimeOfDay(hour: 21, minute: 0),
      durationMinutes: 45, // 21:00 - 21:45
    );

    test('At 09:30, DBMS is the current task', () {
      final nowAt930 = DateTime(2026, 10, 7, 9, 30);

      expect(dbmsTask.isCurrent(nowAt930), isTrue);
      expect(pythonTask.isCurrent(nowAt930), isFalse);
      expect(animeTask.isCurrent(nowAt930), isFalse);
    });

    test('At 08:45, no task is current, and DBMS is upcoming', () {
      final nowAt845 = DateTime(2026, 10, 7, 8, 45);

      expect(dbmsTask.isCurrent(nowAt845), isFalse);
      expect(dbmsTask.isUpcoming(nowAt845), isTrue);
      expect(pythonTask.isUpcoming(nowAt845), isTrue);
    });

    test('At 10:05, DBMS is past, Python is current', () {
      final nowAt1005 = DateTime(2026, 10, 7, 10, 5);

      expect(dbmsTask.isCurrent(nowAt1005), isFalse);
      expect(dbmsTask.isPast(nowAt1005), isTrue);
      expect(pythonTask.isCurrent(nowAt1005), isTrue);
    });

    test('Completed task is never returned as current or upcoming', () {
      final nowAt930 = DateTime(2026, 10, 7, 9, 30);
      final completedDbms = dbmsTask.copyWith(isCompleted: true);

      expect(completedDbms.isCurrent(nowAt930), isFalse);
      expect(completedDbms.isUpcoming(nowAt930), isFalse);
    });

    test('Skipped task is never returned as current or upcoming', () {
      final nowAt930 = DateTime(2026, 10, 7, 9, 30);
      final skippedDbms = dbmsTask.copyWith(isSkipped: true);

      expect(skippedDbms.isCurrent(nowAt930), isFalse);
      expect(skippedDbms.isUpcoming(nowAt930), isFalse);
    });

    test('Chronological sorting orders tasks correctly by time', () {
      final tasks = [animeTask, pythonTask, dbmsTask];

      tasks.sort((a, b) {
        final hourComp = a.startTime.hour.compareTo(b.startTime.hour);
        if (hourComp != 0) return hourComp;
        return a.startTime.minute.compareTo(b.startTime.minute);
      });

      expect(tasks[0].id, 1); // DBMS (09:00)
      expect(tasks[1].id, 2); // Python (10:00)
      expect(tasks[2].id, 3); // Anime (21:00)
    });
  });
}
