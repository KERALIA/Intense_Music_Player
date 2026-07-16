import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/duplicate_cleaner_service.dart';

/// Provider for the duplicate cleaner service.
final duplicateCleanerServiceProvider = Provider<DuplicateCleanerService>((ref) {
  return DuplicateCleanerService();
});

/// State for duplicate scan results.
class DuplicateScanState {
  final DuplicateScanResult? result;
  final bool isScanning;
  final bool isRemoving;
  final String? error;
  
  const DuplicateScanState({
    this.result,
    this.isScanning = false,
    this.isRemoving = false,
    this.error,
  });
  
  DuplicateScanState copyWith({
    DuplicateScanResult? result,
    bool? isScanning,
    bool? isRemoving,
    String? error,
  }) {
    return DuplicateScanState(
      result: result ?? this.result,
      isScanning: isScanning ?? this.isScanning,
      isRemoving: isRemoving ?? this.isRemoving,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing duplicate scan state.
class DuplicateScanNotifier extends Notifier<DuplicateScanState> {
  @override
  DuplicateScanState build() => const DuplicateScanState();
  
  Future<void> scanForDuplicates() async {
    state = state.copyWith(isScanning: true, error: null);
    
    try {
      final service = ref.read(duplicateCleanerServiceProvider);
      final result = await service.scanForDuplicates();
      
      state = state.copyWith(
        result: result,
        isScanning: false,
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> removeAllDuplicates() async {
    if (state.result == null) return;
    
    state = state.copyWith(isRemoving: true, error: null);
    
    try {
      final service = ref.read(duplicateCleanerServiceProvider);
      await service.removeAllDuplicates(
        state.result!.duplicateGroups,
      );
      
      // Rescan after removal
      await scanForDuplicates();
      
      state = state.copyWith(isRemoving: false);
    } catch (e) {
      state = state.copyWith(
        isRemoving: false,
        error: e.toString(),
      );
    }
  }
  
  void clearResults() {
    state = const DuplicateScanState();
  }
}

/// Provider for duplicate scan state.
final duplicateScanProvider = NotifierProvider<DuplicateScanNotifier, DuplicateScanState>(
  DuplicateScanNotifier.new,
);
