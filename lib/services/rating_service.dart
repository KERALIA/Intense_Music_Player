import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const String _ratingsKey = 'song_ratings';

  Map<String, int> _ratings = {};
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ratingsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _ratings = decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {
        _ratings = {};
      }
    }
    _isLoaded = true;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ratingsKey, jsonEncode(_ratings));
  }

  Future<int> getRating(String songId) async {
    await _ensureLoaded();
    return _ratings[songId] ?? 0;
  }

  Future<void> setRating(String songId, int rating) async {
    await _ensureLoaded();
    if (rating == 0) {
      _ratings.remove(songId);
    } else {
      _ratings[songId] = rating.clamp(1, 5);
    }
    await _save();
  }

  Future<Map<String, int>> getAllRatings() async {
    await _ensureLoaded();
    return Map.from(_ratings);
  }
}