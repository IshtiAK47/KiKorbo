import 'package:flutter/material.dart';
import 'app_theme_data.dart';

class AppThemes {
  static const String minimalId = 'minimal';
  static const String midnightId = 'midnight';
  static const String sakuraId = 'sakura';
  static const String forestId = 'forest';
  static const String arcadeId = 'arcade';
  static const String cosmosId = 'cosmos';

  static final AppThemeData minimal = AppThemeData(
    id: minimalId,
    name: 'Minimal',
    description: 'Clean & calm off-white monochrome',
    isDark: false,
    background: const Color(0xFFFBFBFD),
    surface: const Color(0xFFFFFFFF),
    surfaceCard: const Color(0xFFF3F3F7),
    surfaceAccent: const Color(0xFFE5E5EB),
    primary: const Color(0xFF18181B),
    primaryVariant: const Color(0xFF27272A),
    secondary: const Color(0xFF71717A),
    textPrimary: const Color(0xFF09090B),
    textSecondary: const Color(0xFF52525B),
    textMuted: const Color(0xFFA1A1AA),
    border: const Color(0xFFE4E4E7),
    divider: const Color(0xFFEFEFF2),
    success: const Color(0xFF10B981),
    warning: const Color(0xFFF59E0B),
    error: const Color(0xFFEF4444),
    glowColor: Colors.transparent,
    cardRadius: 24.0,
    buttonRadius: 18.0,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
    glowShadow: const [],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      color: Color(0xFF09090B),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF09090B),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFF09090B),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF09090B),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF52525B),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF71717A),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Color(0xFFA1A1AA),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.0,
      color: Color(0xFF09090B),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final AppThemeData midnight = AppThemeData(
    id: midnightId,
    name: 'Midnight',
    description: 'Deep navy-black with cyan luminescence',
    isDark: true,
    background: const Color(0xFF090D16),
    surface: const Color(0xFF111726),
    surfaceCard: const Color(0xFF151E32),
    surfaceAccent: const Color(0xFF1E2B47),
    primary: const Color(0xFF38BDF8),
    primaryVariant: const Color(0xFF0284C7),
    secondary: const Color(0xFF818CF8),
    textPrimary: const Color(0xFFF8FAFC),
    textSecondary: const Color(0xFF94A3B8),
    textMuted: const Color(0xFF64748B),
    border: const Color(0x3038BDF8),
    divider: const Color(0xFF1E293B),
    success: const Color(0xFF34D399),
    warning: const Color(0xFFFBBF24),
    error: const Color(0xFFF87171),
    glowColor: const Color(0x3538BDF8),
    cardRadius: 26.0,
    buttonRadius: 18.0,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
    glowShadow: [
      BoxShadow(
        color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
        blurRadius: 24,
        spreadRadius: 1,
      ),
    ],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      color: Color(0xFFF8FAFC),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFFF8FAFC),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFFF8FAFC),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF8FAFC),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF94A3B8),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF64748B),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Color(0xFF38BDF8),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.0,
      color: Color(0xFFF8FAFC),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final AppThemeData sakura = AppThemeData(
    id: sakuraId,
    name: 'Sakura',
    description: 'Serene warm ivory with soft rose blossom',
    isDark: false,
    background: const Color(0xFFFAF5F0),
    surface: const Color(0xFFFFFBF7),
    surfaceCard: const Color(0xFFF4ECE4),
    surfaceAccent: const Color(0xFFE8DCDB),
    primary: const Color(0xFFE11D48),
    primaryVariant: const Color(0xFFBE123C),
    secondary: const Color(0xFFFB7185),
    textPrimary: const Color(0xFF2E1020),
    textSecondary: const Color(0xFF704354),
    textMuted: const Color(0xFFA88293),
    border: const Color(0x35FB7185),
    divider: const Color(0xFFEDE0D9),
    success: const Color(0xFF10B981),
    warning: const Color(0xFFF59E0B),
    error: const Color(0xFFEF4444),
    glowColor: const Color(0x25FB7185),
    cardRadius: 28.0,
    buttonRadius: 20.0,
    cardShadow: [
      BoxShadow(
        color: const Color(0xFFE11D48).withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 5),
      ),
    ],
    glowShadow: [
      BoxShadow(
        color: const Color(0xFFFB7185).withValues(alpha: 0.15),
        blurRadius: 20,
      ),
    ],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      color: Color(0xFF2E1020),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF2E1020),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFF2E1020),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2E1020),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF704354),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFFA88293),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Color(0xFFE11D48),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.0,
      color: Color(0xFF2E1020),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final AppThemeData forest = AppThemeData(
    id: forestId,
    name: 'Forest',
    description: 'Deep woodland green with emerald tranquility',
    isDark: true,
    background: const Color(0xFF0C1712),
    surface: const Color(0xFF14241D),
    surfaceCard: const Color(0xFF192E25),
    surfaceAccent: const Color(0xFF243F33),
    primary: const Color(0xFF34D399),
    primaryVariant: const Color(0xFF059669),
    secondary: const Color(0xFFA7F3D0),
    textPrimary: const Color(0xFFECFDF5),
    textSecondary: const Color(0xFF8FD8B3),
    textMuted: const Color(0xFF5B997B),
    border: const Color(0x3034D399),
    divider: const Color(0xFF1F3B2F),
    success: const Color(0xFF34D399),
    warning: const Color(0xFFFBBF24),
    error: const Color(0xFFF87171),
    glowColor: const Color(0x3034D399),
    cardRadius: 26.0,
    buttonRadius: 18.0,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 18,
        offset: const Offset(0, 5),
      ),
    ],
    glowShadow: [
      BoxShadow(
        color: const Color(0xFF34D399).withValues(alpha: 0.18),
        blurRadius: 24,
      ),
    ],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      color: Color(0xFFECFDF5),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFFECFDF5),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFFECFDF5),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFFECFDF5),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF8FD8B3),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF5B997B),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Color(0xFF34D399),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.0,
      color: Color(0xFFECFDF5),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final AppThemeData arcade = AppThemeData(
    id: arcadeId,
    name: 'Arcade',
    description: 'Retro synthwave slate with vibrant amber & crimson',
    isDark: true,
    background: const Color(0xFF10101A),
    surface: const Color(0xFF1A1A28),
    surfaceCard: const Color(0xFF222235),
    surfaceAccent: const Color(0xFF2D2D45),
    primary: const Color(0xFFFF9F1C),
    primaryVariant: const Color(0xFFF77F00),
    secondary: const Color(0xFF2EC4B6),
    textPrimary: const Color(0xFFFDFFFC),
    textSecondary: const Color(0xFFCBD5E1),
    textMuted: const Color(0xFF828A9E),
    border: const Color(0x40FF9F1C),
    divider: const Color(0xFF2A2A40),
    success: const Color(0xFF2EC4B6),
    warning: const Color(0xFFFF9F1C),
    error: const Color(0xFFE71D36),
    glowColor: const Color(0x35FF9F1C),
    cardRadius: 20.0,
    buttonRadius: 14.0,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
    glowShadow: [
      BoxShadow(
        color: const Color(0xFFFF9F1C).withValues(alpha: 0.22),
        blurRadius: 22,
      ),
    ],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
      color: Color(0xFFFDFFFC),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
      color: Color(0xFFFDFFFC),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFDFFFC),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFDFFFC),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xFFCBD5E1),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF828A9E),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.4,
      color: Color(0xFFFF9F1C),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      color: Color(0xFFFDFFFC),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final AppThemeData cosmos = AppThemeData(
    id: cosmosId,
    name: 'Cosmos',
    description: 'Interstellar night sky with dreamy nebula violet',
    isDark: true,
    background: const Color(0xFF080614),
    surface: const Color(0xFF120E26),
    surfaceCard: const Color(0xFF1B1538),
    surfaceAccent: const Color(0xFF271F4E),
    primary: const Color(0xFFA855F7),
    primaryVariant: const Color(0xFF9333EA),
    secondary: const Color(0xFFC084FC),
    textPrimary: const Color(0xFFFAF5FF),
    textSecondary: const Color(0xFFD8B4FE),
    textMuted: const Color(0xFF8A6EA8),
    border: const Color(0x35A855F7),
    divider: const Color(0xFF241B45),
    success: const Color(0xFF34D399),
    warning: const Color(0xFFFBBF24),
    error: const Color(0xFFF87171),
    glowColor: const Color(0x35A855F7),
    cardRadius: 26.0,
    buttonRadius: 18.0,
    cardShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 22,
        offset: const Offset(0, 6),
      ),
    ],
    glowShadow: [
      BoxShadow(
        color: const Color(0xFFA855F7).withValues(alpha: 0.22),
        blurRadius: 26,
      ),
    ],
    headingLarge: const TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      color: Color(0xFFFAF5FF),
      height: 1.1,
    ),
    headingMedium: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFFFAF5FF),
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFFFAF5FF),
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFAF5FF),
    ),
    bodyLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFFD8B4FE),
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF8A6EA8),
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Color(0xFFA855F7),
    ),
    timerDigits: const TextStyle(
      fontSize: 68,
      fontWeight: FontWeight.w700,
      letterSpacing: -2.0,
      color: Color(0xFFFAF5FF),
      fontFeatures: [FontFeature.tabularFigures()],
    ),
  );

  static final List<AppThemeData> allThemes = [
    midnight,
    minimal,
    sakura,
    forest,
    arcade,
    cosmos,
  ];

  static AppThemeData getThemeById(String id) {
    return allThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => midnight,
    );
  }
}
