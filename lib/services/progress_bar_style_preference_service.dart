import 'package:shared_preferences/shared_preferences.dart';

import 'package:intense_audio_player/models/progress_bar_style.dart';

class ProgressBarStylePreferenceService {
  static const _key = 'progress_bar_style';

  Future<ProgressBarStyle> getStyle() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressBarStyleX.fromStorageValue(prefs.getString(_key));
  }

  Future<void> setStyle(ProgressBarStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, style.storageValue);
  }
}
