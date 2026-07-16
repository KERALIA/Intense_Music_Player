import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:intense_audio_player/core/utils/dev_log.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_api_client.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_models.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_scrobble_service.dart';

/// Offline-safe ListenBrainz listen queue persisted in SharedPreferences.
class ListenBrainzScrobbleQueue {
  ListenBrainzScrobbleQueue({ListenBrainzScrobbleService? service})
    : _service = service ?? ListenBrainzScrobbleService();

  final ListenBrainzScrobbleService _service;
  static const _kQueueKey = 'listenbrainz_scrobble_queue_v1';
  static const _kMaxQueueSize = 1000;

  Future<void> enqueue(ListenBrainzListenEntry entry) async {
    final queue = await _load();
    queue.add(entry.toJson());
    // Drop oldest entries if queue exceeds max size
    if (queue.length > _kMaxQueueSize) {
      final dropped = queue.length - _kMaxQueueSize;
      queue.removeRange(0, dropped);
      devLog('[ListenBrainz] queue overflow: dropped $dropped oldest entries');
    }
    devLog(
      '[ListenBrainz] queue enqueue artist="${entry.artistName}" track="${entry.trackName}" pending=${queue.length}',
    );
    await _save(queue);
  }

  /// Attempts to flush all queued listens.
  /// Keeps queue intact on failure for future retries.
  Future<void> flush() async {
    final raw = await _load();
    if (raw.isEmpty) {
      devLog('[ListenBrainz] queue flush skipped: empty');
      return;
    }

    devLog('[ListenBrainz] queue flush start pending=${raw.length}');

    final entries = raw
        .map(
          (entry) => ListenBrainzListenEntry.fromJson(
            Map<String, dynamic>.from(entry as Map),
          ),
        )
        .toList();

    try {
      await _service.scrobbleBatch(entries);
      await _clear();
      devLog('[ListenBrainz] queue flush success; queue cleared');
    } on ListenBrainzNoTokenException {
      // No active token — keep queue intact for later retry after login
      devLog('[ListenBrainz] queue flush skipped: no token; queue retained');
      return;
    } on ListenBrainzApiException catch (e) {
      if (e.statusCode == 401) {
        // Invalid token — keep queue; user must re-auth before retry
        devLog(
          '[ListenBrainz] queue flush failed: token invalid (401); queue retained until re-auth',
        );
        return;
      }
      devLog('[ListenBrainz] queue flush failed; queue retained');
      rethrow;
    } catch (_) {
      devLog('[ListenBrainz] queue flush failed; queue retained');
      rethrow;
    }
  }

  Future<int> get pendingCount async {
    return (await _load()).length;
  }

  Future<List<dynamic>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kQueueKey);
    if (raw == null) {
      return [];
    }
    try {
      return jsonDecode(raw) as List<dynamic>;
    } catch (e) {
      // Malformed or incompatible JSON; clear stored queue and start fresh
      devLog('[ListenBrainz] queue load failed; clearing corrupt data: $e');
      await prefs.remove(_kQueueKey);
      return [];
    }
  }

  Future<void> _save(List<dynamic> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kQueueKey, jsonEncode(queue));
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kQueueKey);
  }
}
