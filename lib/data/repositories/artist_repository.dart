import 'package:isar_community/isar.dart';

import '../database.dart';

/// Repository for cached per-artist metadata.
class ArtistRepository {
  final Isar _isar;

  ArtistRepository({Isar? isar}) : _isar = isar ?? Database.instance;

  /// Look up an artist record by name (case-insensitive).
  Future<ArtistEntity?> getByName(String name) async {
    if (name.isEmpty) return null;
    return _isar.artistEntitys
        .filter()
        .nameEqualTo(name, caseSensitive: false)
        .findFirst();
  }

  /// Set or clear the cached art path for an artist.
  Future<void> setArt(String name, String? artPath) async {
    if (name.isEmpty) return;
    await _isar.writeTxn(() async {
      final existing = await _isar.artistEntitys
          .filter()
          .nameEqualTo(name, caseSensitive: false)
          .findFirst();

      if (existing != null) {
        if (existing.artPath == artPath) return;
        existing.artPath = artPath;
        await _isar.artistEntitys.put(existing);
        return;
      }

      final entity = ArtistEntity()
        ..name = name
        ..artPath = artPath;
      await _isar.artistEntitys.put(entity);
    });
  }

  Future<void> clearArt(String name) => setArt(name, null);
}
