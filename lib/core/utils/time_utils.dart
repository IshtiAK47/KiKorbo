import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimeOfDay(TimeOfDay time, {bool is24Hour = false}) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (is24Hour) {
      return DateFormat('HH:mm').format(dt);
    }
    return DateFormat('h:mm a').format(dt);
  }

  static String formatTimeRange(TimeOfDay start, int durationMinutes) {
    final now = DateTime.now();
    final startDt = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDt = startDt.add(Duration(minutes: durationMinutes));
    
    final startStr = DateFormat('h:mm').format(startDt);
    final endStr = DateFormat('h:mm a').format(endDt);
    return '$startStr — $endStr';
  }

  static String formatDateHeader(DateTime date) {
    return DateFormat('EEEE\nd MMMM').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String formatDayOfMonth(DateTime date) {
    return DateFormat('d').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours hr';
    }
    return '$hours hr $mins min';
  }

  static TimeOfDay nextQuarterHour([DateTime? from]) {
    final now = from ?? DateTime.now();
    final nextMin = ((now.minute / 15).floor() + 1) * 15;
    if (nextMin >= 60) {
      return TimeOfDay(hour: (now.hour + 1) % 24, minute: 0);
    }
    return TimeOfDay(hour: now.hour, minute: nextMin);
  }
}
