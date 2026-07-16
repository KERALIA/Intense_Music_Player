import 'package:flutter/services.dart';

/// Centralized haptic patterns used across Flick interactions.
class AppHaptics {
  AppHaptics._();

  static bool _enabled = true;

  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Wraps a callback so it fires [tap] haptic before executing.
  static VoidCallback wrap(VoidCallback callback) {
    return () {
      tap();
      callback();
    };
  }

  /// Wraps an async callback so it fires [tap] haptic before executing.
  static Future<void> Function() wrapAsync(Future<void> Function() callback) {
    return () async {
      tap();
      await callback();
    };
  }

  static void tap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
  }

  static void selection() {
    if (!_enabled) return;
    HapticFeedback.selectionClick();
  }

  static void confirm() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }

  static void emphasis() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }
}
