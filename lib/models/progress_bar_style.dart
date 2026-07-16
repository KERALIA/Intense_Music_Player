enum ProgressBarStyle { waveform, line }

extension ProgressBarStyleX on ProgressBarStyle {
  String get storageValue {
    switch (this) {
      case ProgressBarStyle.waveform:
        return 'waveform';
      case ProgressBarStyle.line:
        return 'line';
    }
  }

  String get label {
    switch (this) {
      case ProgressBarStyle.waveform:
        return 'Waveform';
      case ProgressBarStyle.line:
        return 'Line';
    }
  }

  String get description {
    switch (this) {
      case ProgressBarStyle.waveform:
        return 'Vertical bars that animate across the screen.';
      case ProgressBarStyle.line:
        return 'Clean straight line with precision scrubbing.';
    }
  }

  static ProgressBarStyle fromStorageValue(String? value) {
    switch (value) {
      case 'line':
        return ProgressBarStyle.line;
      case 'waveform':
      default:
        return ProgressBarStyle.waveform;
    }
  }
}
