import 'package:flutter_test/flutter_test.dart';
import 'package:intense_audio_player/services/player_service.dart';

void main() {
  group('shouldSyncNotificationForRepeatOneLoop', () {
    test('returns true when repeat-one wraps from the end to the start', () {
      expect(
        shouldSyncNotificationForRepeatOneLoop(
          loopMode: LoopMode.one,
          sameTrack: true,
          previousPosition: const Duration(minutes: 2, seconds: 58),
          currentPosition: const Duration(milliseconds: 120),
          trackDuration: const Duration(minutes: 3),
        ),
        isTrue,
      );
    });

    test('returns false for normal progress updates on the same track', () {
      expect(
        shouldSyncNotificationForRepeatOneLoop(
          loopMode: LoopMode.one,
          sameTrack: true,
          previousPosition: const Duration(minutes: 1),
          currentPosition: const Duration(minutes: 1, seconds: 2),
          trackDuration: const Duration(minutes: 3),
        ),
        isFalse,
      );
    });

    test('returns false when repeat-one is not active', () {
      expect(
        shouldSyncNotificationForRepeatOneLoop(
          loopMode: LoopMode.all,
          sameTrack: true,
          previousPosition: const Duration(minutes: 2, seconds: 58),
          currentPosition: const Duration(milliseconds: 120),
          trackDuration: const Duration(minutes: 3),
        ),
        isFalse,
      );
    });
  });

  group('shouldTrackReplayFromPlaybackState', () {
    test('tracks progress updates for non-Rust playback', () {
      expect(
        shouldTrackReplayFromPlaybackState(
          usingRustBackend: false,
          previousPosition: const Duration(seconds: 10),
          currentPosition: const Duration(seconds: 11),
        ),
        isTrue,
      );
    });

    test('ignores duplicate playback-state positions', () {
      expect(
        shouldTrackReplayFromPlaybackState(
          usingRustBackend: false,
          previousPosition: const Duration(seconds: 10),
          currentPosition: const Duration(seconds: 10),
        ),
        isFalse,
      );
    });

    test('defers to the dedicated Rust position listener', () {
      expect(
        shouldTrackReplayFromPlaybackState(
          usingRustBackend: true,
          previousPosition: const Duration(seconds: 10),
          currentPosition: const Duration(seconds: 11),
        ),
        isFalse,
      );
    });
  });
}
