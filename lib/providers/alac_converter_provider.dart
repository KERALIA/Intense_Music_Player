import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intense_audio_player/services/alac_converter_service.dart';
import 'package:intense_audio_player/src/rust/api/alac_converter_api.dart' as alac_api;

/// Provider for ALAC converter service
final alacConverterServiceProvider = Provider<AlacConverterService>((ref) {
  return AlacConverterService();
});

/// Provider for checking if a file needs WAV conversion before playback.
final needsAlacConversionProvider = Provider.family<bool, String>((
  ref,
  filePath,
) {
  return AlacConverterService.requiresWavConversion(filePath);
});

/// Provider for ALAC audio metadata
final alacMetadataProvider =
    FutureProvider.family<alac_api.AlacAudioMetadata?, String>((
      ref,
      filePath,
    ) async {
      if (!AlacConverterService.requiresWavConversion(filePath)) {
        return null;
      }

      try {
        return await AlacConverterService.probeMetadata(filePath);
      } catch (e) {
        return null;
      }
    });

/// State for tracking conversion progress
class ConversionProgress {
  final String filePath;
  final bool isConverting;
  final String? convertedPath;
  final String? error;

  const ConversionProgress({
    required this.filePath,
    this.isConverting = false,
    this.convertedPath,
    this.error,
  });

  ConversionProgress copyWith({
    String? filePath,
    bool? isConverting,
    String? convertedPath,
    String? error,
  }) {
    return ConversionProgress(
      filePath: filePath ?? this.filePath,
      isConverting: isConverting ?? this.isConverting,
      convertedPath: convertedPath ?? this.convertedPath,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing ALAC conversion state
class AlacConversionNotifier extends Notifier<Map<String, ConversionProgress>> {
  @override
  Map<String, ConversionProgress> build() {
    return {};
  }

  /// Convert a file and track progress
  Future<String?> convertFile(String filePath) async {
    // Check if already converted
    if (state[filePath]?.convertedPath != null) {
      return state[filePath]!.convertedPath;
    }

    // Start conversion
    state = {
      ...state,
      filePath: ConversionProgress(filePath: filePath, isConverting: true),
    };

    try {
      final convertedPath = await AlacConverterService.convertToWavFile(
        filePath,
      );

      state = {
        ...state,
        filePath: ConversionProgress(
          filePath: filePath,
          isConverting: false,
          convertedPath: convertedPath,
        ),
      };

      return convertedPath;
    } catch (e) {
      state = {
        ...state,
        filePath: ConversionProgress(
          filePath: filePath,
          isConverting: false,
          error: e.toString(),
        ),
      };
      return null;
    }
  }

  /// Clear conversion cache for a file
  void clearConversion(String filePath) {
    final newState = Map<String, ConversionProgress>.from(state);
    newState.remove(filePath);
    state = newState;
  }

  /// Clear all conversions
  void clearAll() {
    state = {};
  }
}

/// Provider for ALAC conversion state management
final alacConversionProvider =
    NotifierProvider<AlacConversionNotifier, Map<String, ConversionProgress>>(
      () {
        return AlacConversionNotifier();
      },
    );
