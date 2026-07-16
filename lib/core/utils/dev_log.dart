import 'package:flutter/foundation.dart';
import 'package:intense_audio_player/services/uac2_preferences_service.dart';
import 'package:intense_audio_player/core/utils/app_log.dart';

void devLog(String message) {
  if (!Uac2PreferencesService.isDeveloperModeEnabledSync) return;
  AppLog.instance.add(message, source: LogSource.dart);
  debugPrint(message);
}
