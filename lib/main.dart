import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/services/notification_service.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/theme_provider.dart';
import 'core/utils/haptics_helper.dart';
import 'features/home/controllers/home_controller.dart';
import 'features/navigation/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize preferences
  final prefsService = await PreferencesService.init();

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.init();
  notificationService.notificationsEnabled = prefsService.notificationsEnabled;
  HapticsHelper.enabled = prefsService.hapticsEnabled;

  // Transparent system navigation and status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(prefsService),
      ],
      child: const KiKorboApp(),
    ),
  );
}

class KiKorboApp extends ConsumerWidget {
  const KiKorboApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(themeNotifierProvider);

    return AppThemeInherited(
      theme: activeTheme,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: activeTheme.toFlutterTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final repo = ref.read(taskRepositoryProvider);
    // Seed nice demo tasks if first time
    await repo.seedSampleTasksIfEmpty();

    // Short polite splash delay for smooth entrance
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScaffold(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) => FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.primaryVariant],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                style: theme.headingLarge.copyWith(letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              Text(
                AppConstants.tagline,
                style: theme.bodyMedium.copyWith(color: theme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
