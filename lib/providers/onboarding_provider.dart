import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCompletedNotifier extends Notifier<bool> {
  static const _prefKey = 'onboarding_completed';
  bool _initialized = false;

  @override
  bool build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(_loadPreference);
    }
    return false;
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_prefKey) ?? false;
    if (!ref.mounted) return;
    state = value;
  }

  Future<void> complete() async {
    if (state) return;
    state = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
  }

  Future<void> reset() async {
    state = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, false);
  }
}

final onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
      OnboardingCompletedNotifier.new,
    );
