import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/widgets/bounce_tappable.dart';
import '../../../core/widgets/custom_chip.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(begin: begin, end: end).animate(curve),
            child: child,
          );
        },
      ),
    );
  }

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<int> _focusOptions = [15, 25, 40, 50];
  final List<int> _breakOptions = [3, 5, 10, 15];

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final prefs = ref.watch(preferencesServiceProvider);
    final activeTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // Section: Appearance
          Text(
            'VISUAL THEME',
            style: theme.labelSmall.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          // 6 Themes grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppThemes.allThemes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final t = AppThemes.allThemes[index];
              final isSelected = t.id == activeTheme.id;

              return BounceTappable(
                onTap: () {
                  HapticsHelper.selection();
                  ref.read(themeNotifierProvider.notifier).setTheme(t.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.background,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? t.primary : t.border,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: t.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: t.textPrimary,
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, size: 16, color: t.primary),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: t.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: t.secondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: t.surfaceCard,
                              border: Border.all(color: t.border),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Section: Timer
          Text(
            'TIMER PREFERENCES',
            style: theme.labelSmall.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.surfaceCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Focus Session',
                  style: theme.titleMedium.copyWith(fontSize: 15.0),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _focusOptions.map((mins) {
                    final isSelected = prefs.focusMinutes == mins;
                    return CustomChip(
                      label: '$mins min',
                      isSelected: isSelected,
                      onTap: () async {
                        HapticsHelper.selection();
                        await prefs.setFocusMinutes(mins);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 18),
                Text(
                  'Default Short Break',
                  style: theme.titleMedium.copyWith(fontSize: 15.0),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _breakOptions.map((mins) {
                    final isSelected = prefs.breakMinutes == mins;
                    return CustomChip(
                      label: '$mins min',
                      isSelected: isSelected,
                      onTap: () async {
                        HapticsHelper.selection();
                        await prefs.setBreakMinutes(mins);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Section: Alerts & Feedback
          Text(
            'ALERTS & FEEDBACK',
            style: theme.labelSmall.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: theme.surfaceCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Task Start Reminders',
                    style: theme.titleMedium.copyWith(fontSize: 15.0),
                  ),
                  subtitle: Text(
                    'Notify when a scheduled task begins',
                    style: theme.bodyMedium.copyWith(color: theme.textMuted),
                  ),
                  activeThumbColor: theme.primary,
                  value: prefs.notificationsEnabled,
                  onChanged: (val) async {
                    HapticsHelper.selection();
                    if (val) {
                      await NotificationService().requestPermissions();
                    }
                    await prefs.setNotificationsEnabled(val);
                    NotificationService().notificationsEnabled = val;
                    setState(() {});
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Haptic Feedback',
                    style: theme.titleMedium.copyWith(fontSize: 15.0),
                  ),
                  subtitle: Text(
                    'Tactile response on taps and completion',
                    style: theme.bodyMedium.copyWith(color: theme.textMuted),
                  ),
                  activeThumbColor: theme.primary,
                  value: prefs.hapticsEnabled,
                  onChanged: (val) async {
                    HapticsHelper.selection();
                    await prefs.setHapticsEnabled(val);
                    HapticsHelper.enabled = val;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Section: About
          Text(
            'ABOUT',
            style: theme.labelSmall.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.surfaceCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: theme.isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: theme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: theme.titleLarge.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Version ${AppConstants.appVersion}',
                          style: theme.bodyMedium.copyWith(color: theme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'A lightweight, beautiful offline-first daily scheduler created to answer one question: "What should I do now?"',
                  style: theme.bodyLarge.copyWith(color: theme.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 14),
                Text(
                  'Made by ${AppConstants.author}',
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
    );
  }
}
