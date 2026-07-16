import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:intense_audio_player/models/song.dart';
import 'package:intense_audio_player/services/player_service.dart';

void main() {
  Song song(String id) => Song(
    id: id,
    title: 'Song $id',
    artist: 'Artist $id',
    duration: const Duration(minutes: 3),
    fileType: 'MP3',
  );

  group('PlayerService shuffle ordering', () {
    test('keeps the current song first when shuffle is enabled', () {
      final songs = [song('a'), song('b'), song('c'), song('d')];

      final reordered = buildShufflePlaybackOrder(
        songs: songs,
        current: songs[2],
        random: math.Random(7),
      );

      expect(reordered, hasLength(songs.length));
      expect(reordered.first.id, 'c');
      expect(reordered.map((item) => item.id).toSet(), {'a', 'b', 'c', 'd'});
    });

    test(
      'restores the original order and reinserts a missing current song',
      () {
        final original = [song('a'), song('b'), song('c')];
        final queuedCurrent = song('x');

        final restored = restorePlaybackOrder(
          originalPlaylist: original,
          current: queuedCurrent,
          insertionIndex: 1,
        );

        expect(restored.map((item) => item.id).toList(), ['a', 'x', 'b', 'c']);
      },
    );
  });
}
