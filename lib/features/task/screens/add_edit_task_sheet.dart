import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_categories.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../core/widgets/custom_chip.dart';
import '../../../data/models/task_model.dart';
import '../../home/controllers/home_controller.dart';

class AddEditTaskSheet extends ConsumerStatefulWidget {
  final TaskModel? taskToEdit;
  final DateTime? initialDate;

  const AddEditTaskSheet({
    super.key,
    this.taskToEdit,
    this.initialDate,
  });

  static Future<void> show(
    BuildContext context, {
    TaskModel? taskToEdit,
    DateTime? initialDate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditTaskSheet(
        taskToEdit: taskToEdit,
        initialDate: initialDate,
      ),
    );
  }

  @override
  ConsumerState<AddEditTaskSheet> createState() => _AddEditTaskSheetState();
}

class _AddEditTaskSheetState extends ConsumerState<AddEditTaskSheet> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late int _durationMinutes;
  late String _selectedCategoryId;
  late String _emoji;
  late TimerType _timerType;

  List<TaskModel> _overlappingTasks = [];

  final List<int> _durationOptions = [15, 25, 30, 45, 60, 90];

  @override
  void initState() {
    super.initState();
    final edit = widget.taskToEdit;
    final now = DateTime.now();

    if (edit != null) {
      _titleController = TextEditingController(text: edit.title);
      _selectedDate = edit.date;
      _startTime = edit.startTime;
      _durationMinutes = edit.durationMinutes;
      _selectedCategoryId = edit.category;
      _emoji = edit.emoji;
      _timerType = edit.timerType;
    } else {
      _titleController = TextEditingController();
      _selectedDate = widget.initialDate ?? DateTime(now.year, now.month, now.day);
      _startTime = TimeUtils.nextQuarterHour(now);
      _durationMinutes = 25;
      _selectedCategoryId = 'study';
      _emoji = '📚';
      _timerType = TimerType.pomodoro;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverlaps();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _checkOverlaps() async {
    final candidate = TaskModel(
      id: widget.taskToEdit?.id,
      title: _titleController.text.trim(),
      date: _selectedDate,
      startTime: _startTime,
      durationMinutes: _durationMinutes,
      category: _selectedCategoryId,
      emoji: _emoji,
      timerType: _timerType,
    );

    final repo = ref.read(taskRepositoryProvider);
    final overlaps = await repo.findOverlappingTasks(
      candidate,
      excludeId: widget.taskToEdit?.id,
    );

    if (mounted) {
      setState(() {
        _overlappingTasks = overlaps;
      });
    }
  }

  Future<void> _pickTime() async {
    HapticsHelper.selection();
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        final theme = context.appTheme;
        return Theme(
          data: theme.toFlutterTheme(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
      _checkOverlaps();
    }
  }

  Future<void> _pickDate() async {
    HapticsHelper.selection();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        final theme = context.appTheme;
        return Theme(
          data: theme.toFlutterTheme(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _checkOverlaps();
    }
  }

  void _onSave() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    HapticsHelper.success();

    final task = TaskModel(
      id: widget.taskToEdit?.id,
      title: title,
      date: _selectedDate,
      startTime: _startTime,
      durationMinutes: _durationMinutes,
      category: _selectedCategoryId,
      emoji: _emoji,
      timerType: _timerType,
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
      isSkipped: widget.taskToEdit?.isSkipped ?? false,
    );

    final notifier = ref.read(tasksProvider.notifier);

    if (widget.taskToEdit == null) {
      await notifier.addTask(task);
    } else {
      await notifier.updateTask(task);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isEditing = widget.taskToEdit != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: theme.border, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Task' : 'New Task',
                  style: theme.titleLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: theme.textSecondary),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  Text(
                    'WHAT DO YOU WANT TO DO?',
                    style: theme.labelSmall.copyWith(fontSize: 10.0),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.surfaceCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.border.withValues(alpha: 0.6)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Text(_emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            autofocus: !isEditing,
                            style: theme.titleMedium.copyWith(fontSize: 16.0),
                            decoration: InputDecoration(
                              hintText: 'e.g. Study DBMS, Workout, Anime...',
                              hintStyle: theme.bodyMedium.copyWith(color: theme.textMuted),
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => _checkOverlaps(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Time & Date Row
                  Row(
                    children: [
                      // When
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WHEN?',
                              style: theme.labelSmall.copyWith(fontSize: 10.0),
                            ),
                            const SizedBox(height: 8),
                            BounceTappable(
                              onTap: _pickTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.surfaceCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.border.withValues(alpha: 0.6),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 18,
                                      color: theme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      TimeUtils.formatTimeOfDay(_startTime),
                                      style: theme.titleMedium.copyWith(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DATE',
                              style: theme.labelSmall.copyWith(fontSize: 10.0),
                            ),
                            const SizedBox(height: 8),
                            BounceTappable(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.surfaceCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.border.withValues(alpha: 0.6),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16,
                                      color: theme.secondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      TimeUtils.isToday(_selectedDate)
                                          ? 'Today'
                                          : TimeUtils.formatShortDate(_selectedDate),
                                      style: theme.titleMedium.copyWith(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Duration Chips
                  Text(
                    'FOR HOW LONG?',
                    style: theme.labelSmall.copyWith(fontSize: 10.0),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _durationOptions.map((duration) {
                      final isSelected = _durationMinutes == duration;
                      return CustomChip(
                        label: '$duration min',
                        isSelected: isSelected,
                        onTap: () {
                          HapticsHelper.selection();
                          setState(() {
                            _durationMinutes = duration;
                          });
                          _checkOverlaps();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Category Selection
                  Text(
                    'CATEGORY',
                    style: theme.labelSmall.copyWith(fontSize: 10.0),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomChip(
                          label: 'None',
                          isSelected: _selectedCategoryId == 'none',
                          onTap: () {
                            HapticsHelper.selection();
                            setState(() {
                              _selectedCategoryId = 'none';
                              _emoji = '📝';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ...TaskCategory.predefined.map((cat) {
                          final isSelected = _selectedCategoryId == cat.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomChip(
                              label: cat.name,
                              emoji: cat.emoji,
                              accentColor: cat.accentColor,
                              isSelected: isSelected,
                              onTap: () {
                                HapticsHelper.selection();
                                setState(() {
                                  _selectedCategoryId = cat.id;
                                  _emoji = cat.emoji;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Timer Mode
                  Text(
                    'TIMER MODE',
                    style: theme.labelSmall.copyWith(fontSize: 10.0),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: TimerType.values.map((type) {
                      final isSelected = _timerType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CustomChip(
                          label: type.label,
                          isSelected: isSelected,
                          onTap: () {
                            HapticsHelper.selection();
                            setState(() {
                              _timerType = type;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  // Overlap Warning Banner
                  if (_overlappingTasks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.warning.withValues(alpha: theme.isDark ? 0.2 : 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.warning.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: theme.warning, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This overlaps with:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: theme.warning,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_overlappingTasks.first.title} (${TimeUtils.formatTimeRange(_overlappingTasks.first.startTime, _overlappingTasks.first.durationMinutes)})',
                                  style: theme.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  // Submit Button
                  BounceTappable(
                    onTap: _onSave,
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.primary, theme.primaryVariant],
                        ),
                        borderRadius: BorderRadius.circular(theme.buttonRadius),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withValues(alpha: 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isEditing ? 'SAVE CHANGES' : 'ADD TO SCHEDULE',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
