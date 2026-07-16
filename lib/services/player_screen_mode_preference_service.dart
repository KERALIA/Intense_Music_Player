import 'package:shared_preferences/shared_preferences.dart';

import 'package:intense_audio_player/models/player_screen_mode.dart';

class PlayerScreenModePreferenceService {
  static const _keyPlayerScreenMode = 'player_screen_mode';

  Future<PlayerScreenMode> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    return PlayerScreenModeX.fromStorageValue(
      prefs.getString(_keyPlayerScreenMode),
    );
  }

  Future<void> setMode(PlayerScreenMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerScreenMode, mode.storageValue);
  }
}
