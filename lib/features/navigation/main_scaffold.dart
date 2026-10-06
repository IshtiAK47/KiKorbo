import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/haptics_helper.dart';
import '../../core/widgets/ambient_background.dart';
import '../../core/widgets/bounce_tappable.dart';
import '../home/screens/home_screen.dart';
import '../schedule/screens/schedule_screen.dart';
import '../task/screens/add_edit_task_sheet.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        // Custom floating bottom bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bottom Pill for Navigation
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: theme.surfaceCard.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: theme.border.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: 'Now',
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard_rounded,
                      theme: theme,
                    ),
                    const SizedBox(width: 8),
                    _buildNavItem(
                      index: 1,
                      label: 'Schedule',
                      icon: Icons.calendar_view_day_outlined,
                      activeIcon: Icons.calendar_view_day_rounded,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              // Floating Action Button (+)
              BounceTappable(
                onTap: () {
                  HapticsHelper.medium();
                  AddEditTaskSheet.show(context);
                },
                scaleLower: 0.92,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.primary,
                        theme.primaryVariant,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required AppThemeData theme,
  }) {
    final isSelected = _currentIndex == index;

    return BounceTappable(
      onTap: () {
        HapticsHelper.selection();
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primary.withValues(alpha: theme.isDark ? 0.22 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? theme.primary : theme.textMuted,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
