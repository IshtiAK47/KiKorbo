import 'package:flutter/services.dart';

class HapticsHelper {
  static bool enabled = true;

  static void light() {
    if (enabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void medium() {
    if (enabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void selection() {
    if (enabled) {
      HapticFeedback.selectionClick();
    }
  }

  static void success() async {
    if (enabled) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 90));
      await HapticFeedback.lightImpact();
    }
  }
}
