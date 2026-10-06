import 'package:flutter/material.dart';

class AppThemeData {
  final String id;
  final String name;
  final String description;
  final bool isDark;

  // Colors
  final Color background;
  final Color surface;
  final Color surfaceCard;
  final Color surfaceAccent;
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color success;
  final Color warning;
  final Color error;
  final Color glowColor;

  // Shapes & Elevation
  final double cardRadius;
  final double buttonRadius;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> glowShadow;

  // Typography details
  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle labelSmall;
  final TextStyle timerDigits;

  const AppThemeData({
    required this.id,
    required this.name,
    required this.description,
    required this.isDark,
    required this.background,
    required this.surface,
    required this.surfaceCard,
    required this.surfaceAccent,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.success,
    required this.warning,
    required this.error,
    required this.glowColor,
    required this.cardRadius,
    required this.buttonRadius,
    required this.cardShadow,
    required this.glowShadow,
    required this.headingLarge,
    required this.headingMedium,
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.labelSmall,
    required this.timerDigits,
  });

  ThemeData toFlutterTheme() {
    final colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      onPrimary: isDark ? Colors.black : Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      error: error,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      cardColor: surfaceCard,
      dividerColor: divider,
      splashFactory: InkRipple.splashFactory,
      fontFamily: null,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: titleLarge.copyWith(color: textPrimary),
      ),
    );
  }
}
