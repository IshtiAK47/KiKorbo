import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  String get selectedThemeKey =>
      _prefs.getString(AppConstants.prefThemeKey) ?? 'midnight';

  Future<bool> setSelectedThemeKey(String key) =>
      _prefs.setString(AppConstants.prefThemeKey, key);

  int get focusMinutes =>
      _prefs.getInt(AppConstants.prefDefaultPomodoroDuration) ?? AppConstants.defaultFocusMinutes;

  Future<bool> setFocusMinutes(int minutes) =>
      _prefs.setInt(AppConstants.prefDefaultPomodoroDuration, minutes);

  int get breakMinutes =>
      _prefs.getInt(AppConstants.prefDefaultBreakDuration) ?? AppConstants.defaultBreakMinutes;

  Future<bool> setBreakMinutes(int minutes) =>
      _prefs.setInt(AppConstants.prefDefaultBreakDuration, minutes);

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.prefNotificationsEnabled) ?? true;

  Future<bool> setNotificationsEnabled(bool enabled) =>
      _prefs.setBool(AppConstants.prefNotificationsEnabled, enabled);

  bool get hapticsEnabled =>
      _prefs.getBool(AppConstants.prefHapticsEnabled) ?? true;

  Future<bool> setHapticsEnabled(bool enabled) =>
      _prefs.setBool(AppConstants.prefHapticsEnabled, enabled);

  bool get isFirstLaunch =>
      !(_prefs.getBool(AppConstants.prefFirstLaunch) ?? false);

  Future<bool> setFirstLaunchCompleted() =>
      _prefs.setBool(AppConstants.prefFirstLaunch, true);
}
