/// Full player layout modes persisted across app launches.
enum PlayerScreenMode { immersive, artworkCard }

extension PlayerScreenModeX on PlayerScreenMode {
  String get storageValue {
    switch (this) {
      case PlayerScreenMode.immersive:
        return 'immersive';
      case PlayerScreenMode.artworkCard:
        return 'artwork_card';
    }
  }

  String get label {
    switch (this) {
      case PlayerScreenMode.immersive:
        return 'Immersive';
      case PlayerScreenMode.artworkCard:
        return 'Artwork Card';
    }
  }

  String get description {
    switch (this) {
      case PlayerScreenMode.immersive:
        return 'Full-bleed album art with the current cinematic look.';
      case PlayerScreenMode.artworkCard:
        return 'Rounded album art card with a blurred album-art background.';
    }
  }

  static PlayerScreenMode fromStorageValue(String? value) {
    switch (value) {
      case 'artwork_card':
        return PlayerScreenMode.artworkCard;
      case 'immersive':
      default:
        return PlayerScreenMode.immersive;
    }
  }
}
