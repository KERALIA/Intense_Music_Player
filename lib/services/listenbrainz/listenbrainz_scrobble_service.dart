import 'package:intense_audio_player/core/constants/app_constants.dart';
import 'package:intense_audio_player/core/utils/dev_log.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_api_client.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_auth_service.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_models.dart';

/// Handles "playing now" and listen submissions to ListenBrainz.
class ListenBrainzScrobbleService {
  ListenBrainzScrobbleService({
    ListenBrainzApiClient? client,
    ListenBrainzAuthService? auth,
  }) : _client = client ?? ListenBrainzApiClient(),
       _auth = auth ?? ListenBrainzAuthService();

  final ListenBrainzApiClient _client;
  final ListenBrainzAuthService _auth;

  /// Returns true if the track meets ListenBrainz listen requirements:
  /// listened to at least half the track or 4 minutes, whichever is lower.
  bool isEligibleToScrobble({
    required int trackDurationSeconds,
    required int listenedSeconds,
  }) {
    if (trackDurationSeconds <= 0) return false;

    final threshold = (trackDurationSeconds / 2).floor();
    final minThreshold = threshold < 240 ? threshold : 240;
    return listenedSeconds >= minThreshold;
  }

  /// Call at playback start to update ListenBrainz "playing_now".
  Future<void> updateNowPlaying(ListenBrainzListenEntry entry) async {
    final session = await _auth.getSession();
    if (session == null) {
      devLog('[ListenBrainz] playing-now skipped: no token');
      return;
    }

    try {
      devLog(
        '[ListenBrainz] playing-now send artist="${entry.artistName}" track="${entry.trackName}"',
      );
      await _client.post(
        '/1/submit-listens',
        body: {
          'listen_type': 'playing_now',
          'payload': [_entryToPayload(entry, includeListenedAt: false)],
        },
      );
      devLog('[ListenBrainz] playing-now success');
    } catch (_) {
      // Playing now is non-critical; failures are intentionally ignored.
      devLog('[ListenBrainz] playing-now failed');
    }
  }

  Future<void> scrobble(ListenBrainzListenEntry entry) async {
    await scrobbleBatch([entry]);
  }

  /// Batch submit listens. Uses `import` listen_type for batches and `single`
  /// for a single entry, matching ListenBrainz conventions.
  Future<void> scrobbleBatch(List<ListenBrainzListenEntry> entries) async {
    if (entries.isEmpty) {
      devLog('[ListenBrainz] scrobble skipped: empty batch');
      return;
    }

    final session = await _auth.getSession();
    if (session == null) {
      devLog('[ListenBrainz] scrobble skipped: no token');
      throw ListenBrainzNoTokenException();
    }

    const maxBatch = 1000;
    final isSingle = entries.length == 1;

    for (var i = 0; i < entries.length; i += maxBatch) {
      final batch = entries.skip(i).take(maxBatch).toList();
      devLog('[ListenBrainz] scrobble send batchSize=${batch.length}');

      await _client.post(
        '/1/submit-listens',
        body: {
          'listen_type': isSingle ? 'single' : 'import',
          'payload':
              batch
                  .map((e) => _entryToPayload(e, includeListenedAt: true))
                  .toList(),
        },
      );
      devLog('[ListenBrainz] scrobble batch success');
    }
  }

  Map<String, dynamic> _entryToPayload(
    ListenBrainzListenEntry entry, {
    required bool includeListenedAt,
  }) {
    final additionalInfo = <String, dynamic>{
      'media_player': 'Flick',
      'submission_client': 'Flick',
      'submission_client_version': kAppVersion,
    };

    if (entry.durationSeconds != null && entry.durationSeconds! > 0) {
      additionalInfo['duration_ms'] = entry.durationSeconds! * 1000;
    }

    final payload = <String, dynamic>{
      'track_metadata': <String, dynamic>{
        'artist_name': entry.artistName,
        'track_name': entry.trackName,
        if (entry.releaseName != null && entry.releaseName!.isNotEmpty)
          'release_name': entry.releaseName,
        'additional_info': additionalInfo,
      },
    };

    if (includeListenedAt) {
      payload['listened_at'] = entry.listenedAt;
    }

    return payload;
  }
}
