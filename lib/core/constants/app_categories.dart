import 'package:flutter/material.dart';

class TaskCategory {
  final String id;
  final String name;
  final String emoji;
  final Color accentColor;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.accentColor,
  });

  static const TaskCategory none = TaskCategory(
    id: 'none',
    name: 'General',
    emoji: '📝',
    accentColor: Color(0xFF94A3B8),
  );

  static const List<TaskCategory> predefined = [
    TaskCategory(
      id: 'study',
      name: 'Study',
      emoji: '📚',
      accentColor: Color(0xFF6366F1),
    ),
    TaskCategory(
      id: 'work',
      name: 'Work',
      emoji: '💻',
      accentColor: Color(0xFF3B82F6),
    ),
    TaskCategory(
      id: 'fitness',
      name: 'Fitness',
      emoji: '⚡',
      accentColor: Color(0xFF10B981),
    ),
    TaskCategory(
      id: 'entertainment',
      name: 'Entertainment',
      emoji: '🎮',
      accentColor: Color(0xFFEC4899),
    ),
    TaskCategory(
      id: 'life',
      name: 'Life',
      emoji: '🌿',
      accentColor: Color(0xFF14B8A6),
    ),
    TaskCategory(
      id: 'other',
      name: 'Other',
      emoji: '✨',
      accentColor: Color(0xFFF59E0B),
    ),
  ];

  static TaskCategory fromId(String? id) {
    if (id == null || id.isEmpty || id == 'none') {
      return none;
    }
    return predefined.firstWhere(
      (c) => c.id == id,
      orElse: () => TaskCategory(
        id: id,
        name: id,
        emoji: '📌',
        accentColor: const Color(0xFF8B5CF6),
      ),
    );
  }
}
