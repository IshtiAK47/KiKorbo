import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../database/app_database.dart';
import '../models/task_model.dart';

class TaskRepository {
  final AppDatabase _db;
  final NotificationService _notifications;

  TaskRepository({
    AppDatabase? db,
    NotificationService? notifications,
  })  : _db = db ?? AppDatabase(),
        _notifications = notifications ?? NotificationService();

  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    final tasks = await _db.getTasksForDate(date);
    // Always sort by date and start time
    tasks.sort((a, b) {
      final hourComp = a.startTime.hour.compareTo(b.startTime.hour);
      if (hourComp != 0) return hourComp;
      return a.startTime.minute.compareTo(b.startTime.minute);
    });
    return tasks;
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final id = await _db.insertTask(task);
    final createdTask = task.copyWith(id: id);
    await _notifications.scheduleTaskNotification(createdTask);
    return createdTask;
  }

  Future<void> updateTask(TaskModel task) async {
    await _db.updateTask(task);
    if (task.id != null) {
      if (task.isCompleted || task.isSkipped) {
        await _notifications.cancelTaskNotification(task.id!);
      } else {
        await _notifications.scheduleTaskNotification(task);
      }
    }
  }

  Future<void> deleteTask(int id) async {
    await _notifications.cancelTaskNotification(id);
    await _db.deleteTask(id);
  }

  Future<void> completeTask(TaskModel task) async {
    final updated = task.copyWith(isCompleted: true, isSkipped: false);
    await updateTask(updated);
  }

  Future<void> uncompleteTask(TaskModel task) async {
    final updated = task.copyWith(isCompleted: false);
    await updateTask(updated);
  }

  Future<void> skipTask(TaskModel task) async {
    final updated = task.copyWith(isSkipped: true, isCompleted: false);
    await updateTask(updated);
  }

  Future<List<TaskModel>> findOverlappingTasks(TaskModel candidate, {int? excludeId}) async {
    final tasks = await getTasksForDate(candidate.date);
    return tasks.where((t) {
      if (excludeId != null && t.id == excludeId) return false;
      if (t.isCompleted || t.isSkipped) return false;
      return candidate.overlapsWith(t);
    }).toList();
  }

  Future<void> seedSampleTasksIfEmpty() async {
    final all = await _db.getAllTasks();
    if (all.isNotEmpty) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final sampleTasks = [
      TaskModel(
        title: 'Morning Routine & Breakfast',
        date: today,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        durationMinutes: 45,
        category: 'life',
        emoji: '🌅',
        timerType: TimerType.none,
      ),
      TaskModel(
        title: 'Study Database Systems',
        date: today,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        durationMinutes: 50,
        category: 'study',
        emoji: '📚',
        timerType: TimerType.pomodoro,
      ),
      TaskModel(
        title: 'Python Practice',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 15),
        durationMinutes: 45,
        category: 'study',
        emoji: '🐍',
        timerType: TimerType.pomodoro,
      ),
      TaskModel(
        title: 'Lunch & Quick Rest',
        date: today,
        startTime: const TimeOfDay(hour: 12, minute: 30),
        durationMinutes: 60,
        category: 'life',
        emoji: '🍱',
        timerType: TimerType.none,
      ),
      TaskModel(
        title: 'Gym & Workout',
        date: today,
        startTime: const TimeOfDay(hour: 16, minute: 0),
        durationMinutes: 50,
        category: 'fitness',
        emoji: '⚡',
        timerType: TimerType.custom,
      ),
      TaskModel(
        title: 'Watch Anime / Relax',
        date: today,
        startTime: const TimeOfDay(hour: 20, minute: 0),
        durationMinutes: 40,
        category: 'entertainment',
        emoji: '🎌',
        timerType: TimerType.none,
      ),
    ];

    for (final task in sampleTasks) {
      await createTask(task);
    }
  }
}
