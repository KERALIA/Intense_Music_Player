import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages ListenBrainz user token and username storage.
class ListenBrainzCredentials {
  ListenBrainzCredentials({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kUserToken = 'listenbrainz_user_token';
  static const _kUsername = 'listenbrainz_username';

  Future<void> setUserToken(String token) async {
    await _storage.write(key: _kUserToken, value: token);
  }

  Future<String?> getUserToken() async {
    return _storage.read(key: _kUserToken);
  }

  Future<void> setUsername(String username) async {
    await _storage.write(key: _kUsername, value: username);
  }

  Future<String?> getUsername() async {
    return _storage.read(key: _kUsername);
  }

  bool hasValidToken({String? token}) {
    final t = token ?? '';
    return t.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _kUserToken);
    await _storage.delete(key: _kUsername);
  }

  Future<void> clearSession() async {
    await clearAll();
  }
}
