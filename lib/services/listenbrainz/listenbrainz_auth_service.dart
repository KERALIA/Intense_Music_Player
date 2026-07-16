import 'package:intense_audio_player/core/utils/dev_log.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_api_client.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_credentials.dart';
import 'package:intense_audio_player/services/listenbrainz/listenbrainz_models.dart';

/// Manages ListenBrainz token validation and session persistence.
class ListenBrainzAuthService {
  ListenBrainzAuthService({
    ListenBrainzApiClient? client,
    ListenBrainzCredentials? credentials,
  }) : _client = client ?? ListenBrainzApiClient(),
       _credentials = credentials ?? ListenBrainzCredentials();

  final ListenBrainzApiClient _client;
  final ListenBrainzCredentials _credentials;

  /// Validates the user token against ListenBrainz and returns the username.
  Future<String> validateToken(String token) async {
    devLog('[ListenBrainz] validateToken: validating token');

    // Temporarily set the token so the client can call validate-token.
    await _credentials.setUserToken(token);

    try {
      final data = await _client.get('/1/validate-token');
      final valid = data['valid'] as bool? ?? false;
      final username = data['user_name'] as String?;

      if (!valid || username == null) {
        throw Exception('Invalid ListenBrainz user token.');
      }

      devLog('[ListenBrainz] validateToken: token valid for user $username');
      return username;
    } catch (e) {
      // Rollback temporary token on failure.
      await _credentials.clearSession();
      rethrow;
    }
  }

  /// Saves the token and username after validation.
  Future<ListenBrainzSession> connect(String token) async {
    final username = await validateToken(token);

    await _credentials.setUserToken(token);
    await _credentials.setUsername(username);

    final session = ListenBrainzSession(token: token, username: username);
    devLog('[ListenBrainz] connect: session saved for $username');
    return session;
  }

  Future<ListenBrainzSession?> getSession() async {
    final token = await _credentials.getUserToken();
    final username = await _credentials.getUsername();

    if (token == null || token.isEmpty || username == null) {
      return null;
    }

    return ListenBrainzSession(token: token, username: username);
  }

  Future<bool> isConnected() async {
    return (await getSession()) != null;
  }

  /// Clears stored token and username (disconnect/logout).
  Future<void> disconnect() async {
    await _credentials.clearSession();
    devLog('[ListenBrainz] disconnect: session cleared');
  }
}
