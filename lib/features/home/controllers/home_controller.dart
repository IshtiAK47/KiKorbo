import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';

// Repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Periodic timer ticker (updates every 15 seconds so NOW / UP NEXT transition seamlessly)
final timeTickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 15),
    (_) => DateTime.now(),
  );
});

// Selected date for schedule screen (defaults to today)
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setDate(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}

final selectedScheduleDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

String _dateKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

// Master Tasks Notifier managing tasks mapped by date string
class TasksNotifier extends Notifier<Map<String, List<TaskModel>>> {
  @override
  Map<String, List<TaskModel>> build() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Load today on init
    Future.microtask(() => loadDate(today));
    return {};
  }

  Future<void> loadDate(DateTime date) async {
    final key = _dateKey(date);
    final repo = ref.read(taskRepositoryProvider);
    try {
      final tasks = await repo.getTasksForDate(date);
      state = {...state, key: tasks};
    } catch (e) {
      debugPrint('Error loading tasks for date $key: $e');
    }
  }

  Future<void> addTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      await repo.createTask(task);
      await loadDate(task.date);
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      await repo.updateTask(task);
      await loadDate(task.date);
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      if (task.id != null) {
        await repo.deleteTask(task.id!);
        await loadDate(task.date);
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  Future<void> completeTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      await repo.completeTask(task);
      await loadDate(task.date);
    } catch (e) {
      debugPrint('Error completing task: $e');
    }
  }

  Future<void> uncompleteTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      await repo.uncompleteTask(task);
      await loadDate(task.date);
    } catch (e) {
      debugPrint('Error uncompleting task: $e');
    }
  }

  Future<void> skipTask(TaskModel task) async {
    final repo = ref.read(taskRepositoryProvider);
    try {
      await repo.skipTask(task);
      await loadDate(task.date);
    } catch (e) {
      debugPrint('Error skipping task: $e');
    }
  }
}

final tasksProvider =
    NotifierProvider<TasksNotifier, Map<String, List<TaskModel>>>(TasksNotifier.new);

// Tasks for specific date
final tasksForDateProvider = Provider.family<List<TaskModel>, DateTime>((ref, date) {
  final all = ref.watch(tasksProvider);
  final key = _dateKey(date);
  if (!all.containsKey(key)) {
    // Trigger load if not yet cached
    Future.microtask(() => ref.read(tasksProvider.notifier).loadDate(date));
    return [];
  }
  return all[key] ?? [];
});

// Convenience provider for Today's tasks
final todayTasksProvider = Provider<List<TaskModel>>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(tasksForDateProvider(today));
});

// Computed provider for Current Active Task
final currentTaskProvider = Provider<TaskModel?>((ref) {
  ref.watch(timeTickerProvider);
  final tasks = ref.watch(todayTasksProvider);
  final now = DateTime.now();

  final activeTasks = tasks.where((t) => t.isCurrent(now)).toList();
  if (activeTasks.isEmpty) return null;

  activeTasks.sort((a, b) {
    final comp = a.startDateTime.compareTo(b.startDateTime);
    if (comp != 0) return comp;
    return a.createdAt.compareTo(b.createdAt);
  });

  return activeTasks.first;
});

// Computed provider for Next Upcoming Task
final nextTaskProvider = Provider<TaskModel?>((ref) {
  ref.watch(timeTickerProvider);
  final tasks = ref.watch(todayTasksProvider);
  final current = ref.watch(currentTaskProvider);
  final now = DateTime.now();

  final candidateTasks = tasks.where((t) {
    if (t.isCompleted || t.isSkipped) return false;
    if (current != null && t.id == current.id) return false;

    if (current != null) {
      return t.startDateTime.isAfter(current.startDateTime) ||
          t.startDateTime.isAtSameMomentAs(current.endDateTime);
    } else {
      return t.startDateTime.isAfter(now);
    }
  }).toList();

  if (candidateTasks.isEmpty) return null;

  candidateTasks.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  return candidateTasks.first;
});

enum DayState {
  empty,
  hasCurrent,
  betweenTasks,
  dayFinished;
}

final dayStateProvider = Provider<DayState>((ref) {
  final tasks = ref.watch(todayTasksProvider);
  final current = ref.watch(currentTaskProvider);
  final next = ref.watch(nextTaskProvider);

  if (tasks.isEmpty) {
    return DayState.empty;
  }
  if (current != null) {
    return DayState.hasCurrent;
  }
  if (next != null) {
    return DayState.betweenTasks;
  }
  return DayState.dayFinished;
});
