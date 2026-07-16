enum ShuffleMode {
  off,
  songs,
  songsAndCategories,
  categories,
  random;

  bool get isActive => this != ShuffleMode.off;

  String get label => switch (this) {
    ShuffleMode.off => 'Off',
    ShuffleMode.songs => 'Songs',
    ShuffleMode.songsAndCategories => 'Songs & Categories',
    ShuffleMode.categories => 'Categories',
    ShuffleMode.random => 'Random',
  };

  String get description => switch (this) {
    ShuffleMode.off => 'Play in order',
    ShuffleMode.songs => 'Shuffle songs in current list',
    ShuffleMode.songsAndCategories => 'Shuffle songs and jump between categories',
    ShuffleMode.categories => 'Play categories in random order, tracks in sequence',
    ShuffleMode.random => 'True random (may repeat before list ends)',
  };
}
