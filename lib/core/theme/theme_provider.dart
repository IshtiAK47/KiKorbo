import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';
import 'app_theme_data.dart';
import 'app_themes.dart';

export 'app_theme_data.dart';
export 'app_themes.dart';

// Provider for PreferencesService
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('Must override in ProviderScope');
});

// Notifier for active theme
class ThemeNotifier extends Notifier<AppThemeData> {
  @override
  AppThemeData build() {
    final prefs = ref.watch(preferencesServiceProvider);
    return AppThemes.getThemeById(prefs.selectedThemeKey);
  }

  Future<void> setTheme(String themeId) async {
    final newTheme = AppThemes.getThemeById(themeId);
    state = newTheme;
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setSelectedThemeKey(themeId);
  }
}

final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, AppThemeData>(ThemeNotifier.new);

// Extension on BuildContext for quick theme access
extension ThemeContextExtension on BuildContext {
  AppThemeData get appTheme {
    final theme = AppThemeInherited.maybeOf(this);
    return theme ?? AppThemes.midnight;
  }
}

class AppThemeInherited extends InheritedWidget {
  final AppThemeData theme;

  const AppThemeInherited({
    super.key,
    required this.theme,
    required super.child,
  });

  static AppThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeInherited>()?.theme;
  }

  static AppThemeData of(BuildContext context) {
    final theme = maybeOf(context);
    assert(theme != null, 'No AppThemeInherited found in context');
    return theme!;
  }

  @override
  bool updateShouldNotify(AppThemeInherited oldWidget) {
    return theme.id != oldWidget.theme.id;
  }
}
