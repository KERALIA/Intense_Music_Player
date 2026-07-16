import 'package:shared_preferences/shared_preferences.dart';

import 'package:intense_audio_player/models/album_color_mode.dart';

class AlbumColorModePreferenceService {
  static const _key = 'album_color_mode';

  Future<AlbumColorMode> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    return AlbumColorModeX.fromStorageValue(prefs.getString(_key));
  }

  Future<void> setMode(AlbumColorMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.storageValue);
  }
}
