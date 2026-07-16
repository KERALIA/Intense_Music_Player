import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intense_audio_player/models/progress_bar_style.dart';
import 'package:intense_audio_player/services/progress_bar_style_preference_service.dart';

final progressBarStylePreferenceServiceProvider =
    Provider<ProgressBarStylePreferenceService>((ref) {
  return ProgressBarStylePreferenceService();
});

class ProgressBarStyleNotifier extends Notifier<ProgressBarStyle> {
  bool _initialized = false;

  @override
  ProgressBarStyle build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(_loadFromPreferences);
    }
    return ProgressBarStyle.waveform;
  }

  Future<void> _loadFromPreferences() async {
    final style =
        await ref.read(progressBarStylePreferenceServiceProvider).getStyle();
    if (ref.mounted && state != style) {
      state = style;
    }
  }

  Future<void> setStyle(ProgressBarStyle style) async {
    if (state == style) return;
    state = style;
    await ref
        .read(progressBarStylePreferenceServiceProvider)
        .setStyle(style);
  }
}

final progressBarStyleProvider =
    NotifierProvider<ProgressBarStyleNotifier, ProgressBarStyle>(
  ProgressBarStyleNotifier.new,
);
