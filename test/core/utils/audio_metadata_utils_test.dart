import 'package:flutter_test/flutter_test.dart';
import 'package:intense_audio_player/core/utils/audio_metadata_utils.dart';

void main() {
  group('AudioMetadataUtils', () {
    test('converts bits per second to kbps for Android metadata', () {
      expect(AudioMetadataUtils.bitrateFromBitsPerSecond(1411200), 1411);
      expect(AudioMetadataUtils.bitrateFromBitsPerSecond(320000), 320);
    });

    test('preserves Rust scanner kbps values', () {
      expect(
        AudioMetadataUtils.normalizeStoredBitrateKbps(
          1134,
          sampleRate: 44100,
          bitDepth: 24,
        ),
        1134,
      );
    });

    test('normalizes legacy stored bits per second values', () {
      expect(
        AudioMetadataUtils.normalizeStoredBitrateKbps(
          1411200,
          sampleRate: 44100,
          bitDepth: 16,
        ),
        1411,
      );
      expect(AudioMetadataUtils.normalizeStoredBitrateKbps(64000), 64);
    });

    test('keeps high resolution kbps values when they match PCM metadata', () {
      expect(
        AudioMetadataUtils.normalizeStoredBitrateKbps(
          18432,
          sampleRate: 384000,
          bitDepth: 24,
        ),
        18432,
      );
    });

    test('formats bitrate labels from mixed stored units', () {
      expect(
        AudioMetadataUtils.formatBitrateLabel(
          706,
          sampleRate: 22050,
          bitDepth: 16,
        ),
        '706kbps',
      );
      expect(AudioMetadataUtils.formatBitrateLabel(64000), '64kbps');
    });
  });
}
