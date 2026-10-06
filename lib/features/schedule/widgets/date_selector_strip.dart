import 'package:flutter/material.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/widgets/bounce_tappable.dart';

class DateSelectorStrip extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelectorStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelectorStrip> createState() => _DateSelectorStripState();
}

class _DateSelectorStripState extends State<DateSelectorStrip> {
  late ScrollController _scrollController;
  final List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Generate 7 days in the past and 14 days in the future
    for (int i = -3; i <= 10; i++) {
      _dates.add(today.add(Duration(days: i)));
    }

    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    final index = _dates.indexWhere((d) => TimeUtils.isSameDay(d, widget.selectedDate));
    if (index != -1 && _scrollController.hasClients) {
      final target = (index * 68.0) - 100.0;
      _scrollController.animateTo(
        target.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void didUpdateWidget(covariant DateSelectorStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!TimeUtils.isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return SizedBox(
      height: 88,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = TimeUtils.isSameDay(date, widget.selectedDate);
          final isToday = TimeUtils.isToday(date);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: BounceTappable(
              onTap: () {
                HapticsHelper.selection();
                widget.onDateSelected(date);
              },
              scaleLower: 0.94,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 62,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primary
                      : (isToday
                          ? theme.surfaceAccent
                          : theme.surfaceCard.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? theme.primary
                        : (isToday ? theme.primary.withValues(alpha: 0.4) : theme.border),
                    width: isSelected || isToday ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TimeUtils.formatDayOfWeek(date).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? theme.primary : theme.textMuted),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      TimeUtils.formatDayOfMonth(date),
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? theme.textPrimary : theme.textSecondary),
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(height: 3),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.white : theme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
