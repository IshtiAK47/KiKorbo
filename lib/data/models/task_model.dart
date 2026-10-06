import 'package:flutter/material.dart';

enum TimerType {
  none,
  pomodoro,
  custom;

  static TimerType fromString(String? val) {
    switch (val) {
      case 'pomodoro':
        return TimerType.pomodoro;
      case 'custom':
        return TimerType.custom;
      default:
        return TimerType.none;
    }
  }

  String get value {
    switch (this) {
      case TimerType.pomodoro:
        return 'pomodoro';
      case TimerType.custom:
        return 'custom';
      case TimerType.none:
        return 'none';
    }
  }

  String get label {
    switch (this) {
      case TimerType.pomodoro:
        return 'Pomodoro (25m)';
      case TimerType.custom:
        return 'Custom Timer';
      case TimerType.none:
        return 'No Timer';
    }
  }
}

class TaskModel {
  final int? id;
  final String title;
  final DateTime date; // YYYY-MM-DD
  final TimeOfDay startTime;
  final int durationMinutes;
  final String category;
  final String emoji;
  final TimerType timerType;
  final bool isCompleted;
  final bool isSkipped;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    this.category = 'none',
    this.emoji = '📝',
    this.timerType = TimerType.pomodoro,
    this.isCompleted = false,
    this.isSkipped = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  DateTime get startDateTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
  }

  DateTime get endDateTime {
    return startDateTime.add(Duration(minutes: durationMinutes));
  }

  bool isCurrent(DateTime now) {
    if (isCompleted || isSkipped) return false;
    final start = startDateTime;
    final end = endDateTime;
    return (now.isAfter(start) || now.isAtSameMomentAs(start)) && now.isBefore(end);
  }

  bool isUpcoming(DateTime now) {
    if (isCompleted || isSkipped) return false;
    return startDateTime.isAfter(now);
  }

  bool isPast(DateTime now) {
    return endDateTime.isBefore(now);
  }

  bool overlapsWith(TaskModel other) {
    // Only check if they are on the same calendar day
    if (date.year != other.date.year ||
        date.month != other.date.month ||
        date.day != other.date.day) {
      return false;
    }
    final s1 = startDateTime;
    final e1 = endDateTime;
    final s2 = other.startDateTime;
    final e2 = other.endDateTime;

    return s1.isBefore(e2) && s2.isBefore(e1);
  }

  TaskModel copyWith({
    int? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    int? durationMinutes,
    String? category,
    String? emoji,
    TimerType? timerType,
    bool? isCompleted,
    bool? isSkipped,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      timerType: timerType ?? this.timerType,
      isCompleted: isCompleted ?? this.isCompleted,
      isSkipped: isSkipped ?? this.isSkipped,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'start_hour': startTime.hour,
      'start_minute': startTime.minute,
      'duration_minutes': durationMinutes,
      'category': category,
      'emoji': emoji,
      'timer_type': timerType.value,
      'is_completed': isCompleted ? 1 : 0,
      'is_skipped': isSkipped ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final dateParts = (map['date'] as String).split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      date: DateTime(year, month, day),
      startTime: TimeOfDay(
        hour: map['start_hour'] as int,
        minute: map['start_minute'] as int,
      ),
      durationMinutes: map['duration_minutes'] as int,
      category: map['category'] as String? ?? 'none',
      emoji: map['emoji'] as String? ?? '📝',
      timerType: TimerType.fromString(map['timer_type'] as String?),
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      isSkipped: (map['is_skipped'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int? ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int? ?? 0),
    );
  }
}
