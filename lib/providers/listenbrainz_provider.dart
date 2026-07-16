import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:intense_audio_player/core/utils/dev_log.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_api_client.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_auth_service.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_credentials.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_models.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_scrobble_queue.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_scrobble_service.dart';

part 'listenbrainz_provider.g.dart';

@Riverpod(keepAlive: true)
ListenBrainzCredentials listenbrainzCredentials(Ref ref) {
  return ListenBrainzCredentials();
}

@Riverpod(keepAlive: true)
ListenBrainzApiClient listenbrainzApiClient(Ref ref) {
  final credentials = ref.watch(listenbrainzCredentialsProvider);
  return ListenBrainzApiClient(credentials: credentials);
}

@Riverpod(keepAlive: true)
ListenBrainzAuthService listenbrainzAuthService(Ref ref) {
  final credentials = ref.watch(listenbrainzCredentialsProvider);
  final client = ref.watch(listenbrainzApiClientProvider);
  return ListenBrainzAuthService(client: client, credentials: credentials);
}

@Riverpod(keepAlive: true)
ListenBrainzScrobbleService listenbrainzScrobbleService(Ref ref) {
  final auth = ref.watch(listenbrainzAuthServiceProvider);
  return ListenBrainzScrobbleService(auth: auth);
}

@Riverpod(keepAlive: true)
ListenBrainzScrobbleQueue listenbrainzScrobbleQueue(Ref ref) {
  final service = ref.watch(listenbrainzScrobbleServiceProvider);
  return ListenBrainzScrobbleQueue(service: service);
}

/// Watches the current ListenBrainz session (null = not connected).
@riverpod
Future<ListenBrainzSession?> listenbrainzSession(Ref ref) async {
  final auth = ref.watch(listenbrainzAuthServiceProvider);
  return auth.getSession();
}

/// Handles ListenBrainz scrobbling lifecycle hooks from playback events.
@Riverpod(keepAlive: true)
class ListenBrainzScrobbleNotifier extends _$ListenBrainzScrobbleNotifier {
  DateTime? _playbackStart;
  ListenBrainzListenEntry? _currentEntry;
  bool _hasScrobbledCurrent = false;

  /// Monotonic counter to cancel stale playing-now calls during rapid
  /// track changes (e.g. gapless transitions).
  int _trackGeneration = 0;

  @override
  void build() {}

  Future<void> onTrackStarted({
    required String artist,
    required String track,
    String? album,
    String? albumArtist,
    int? durationSeconds,
  }) async {
    final gen = ++_trackGeneration;
    _playbackStart = DateTime.now();
    _hasScrobbledCurrent = false;

    // Validate metadata is not corrupted (mojibake/encoding issues)
    if (!_isValidMetadata(artist) || !_isValidMetadata(track)) {
      _currentEntry = null;
      return;
    }

    _currentEntry = ListenBrainzListenEntry(
      artistName: artist,
      trackName: track,
      releaseName: album,
      listenedAt: _playbackStart!.millisecondsSinceEpoch ~/ 1000,
      durationSeconds: durationSeconds,
    );

    // Skip playing-now if a newer onTrackStarted already fired
    if (gen != _trackGeneration) return;

    final scrobbler = ref.read(listenbrainzScrobbleServiceProvider);
    await scrobbler.updateNowPlaying(_currentEntry!);
  }

  /// Called while playback is in progress. Not used for scrobbling—we only
  /// scrobble on explicit track end/skip events to avoid API spam from
  /// repeated progress updates.
  Future<void> onPlaybackProgress({
    String? artist,
    String? track,
    String? album,
    String? albumArtist,
    required int listenedSeconds,
    int? trackDurationSeconds,
  }) async {
    // Scrobbling is triggered only on track-end/skip, not progress updates.
    // This prevents submitting the same track multiple times per second.
  }

  Future<void> onTrackEnded({
    String? artist,
    String? track,
    String? album,
    String? albumArtist,
    required int listenedSeconds,
    int? trackDurationSeconds,
  }) async {
    // Skip scrobbling if metadata is corrupted
    if ((artist != null && !_isValidMetadata(artist)) ||
        (track != null && !_isValidMetadata(track))) {
      _currentEntry = null;
      _playbackStart = null;
      return;
    }
    await _tryScrobble(
      fallbackArtist: artist,
      fallbackTrack: track,
      fallbackAlbum: album,
      fallbackAlbumArtist: albumArtist,
      listenedSeconds: listenedSeconds,
      trackDurationSeconds: trackDurationSeconds,
    );

    _currentEntry = null;
    _playbackStart = null;
  }

  Future<void> _tryScrobble({
    String? fallbackArtist,
    String? fallbackTrack,
    String? fallbackAlbum,
    String? fallbackAlbumArtist,
    required int listenedSeconds,
    int? trackDurationSeconds,
  }) async {
    if (_hasScrobbledCurrent) {
      return;
    }

    final start = _playbackStart;
    var entry = _currentEntry;

    // Prefer fresh fallback metadata (from track-end) over potentially stale
    // _currentEntry. This handles the case where player metadata is corrected
    // between track-start and track-end.
    if (fallbackArtist != null && fallbackTrack != null) {
      final timestamp = DateTime.now()
              .subtract(Duration(seconds: listenedSeconds))
              .millisecondsSinceEpoch ~/
          1000;
      entry = ListenBrainzListenEntry(
        artistName: fallbackArtist,
        trackName: fallbackTrack,
        releaseName: fallbackAlbum,
        listenedAt: timestamp,
        durationSeconds: trackDurationSeconds,
      );
    } else if (entry == null || start == null) {
      return;
    }

    final scrobbler = ref.read(listenbrainzScrobbleServiceProvider);
    final queue = ref.read(listenbrainzScrobbleQueueProvider);

    final durationSeconds =
        (trackDurationSeconds != null && trackDurationSeconds > 0)
            ? trackDurationSeconds
            : entry.durationSeconds;
    if (durationSeconds == null || durationSeconds <= 0) {
      devLog('[ListenBrainz] scrobble skipped: missing or zero duration');
      return;
    }

    final eligible = scrobbler.isEligibleToScrobble(
      trackDurationSeconds: durationSeconds,
      listenedSeconds: listenedSeconds,
    );

    if (!eligible) {
      return;
    }
    await queue.enqueue(entry);
    _hasScrobbledCurrent = true;
    try {
      await queue.flush();
    } catch (e) {
      // Offline or transient failure. Keep queued for later retry.
      devLog('[ListenBrainz] flush failed: $e');
    }
  }

  /// Check if metadata looks valid or corrupted (mojibake pattern detection).
  /// Returns false for garbled text with suspicious UTF-8 sequences.
  bool _isValidMetadata(String text) {
    if (text.isEmpty) return false;

    // Check for mojibake patterns: high density of replacement characters
    // that indicate encoding corruption. Only flag U+FFFD and letterlike
    // symbols — avoid false-positives on legitimate non-Latin scripts
    // (Japanese, Korean, Greek, etc.).
    int suspiciousCharCount = 0;
    for (final char in text.runes) {
      if (char == 0xFFFD || // Replacement char (invalid UTF-8)
          (char >= 0x2100 && char <= 0x214F)) {
        // Letterlike symbols (suspicious)
        suspiciousCharCount++;
      }
    }

    // If more than 40% of characters are suspicious, likely mojibake
    final suspicionRatio = suspiciousCharCount / text.length;
    if (suspicionRatio > 0.4) {
      return false;
    }

    return true;
  }
}
