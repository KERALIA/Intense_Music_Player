/// Audio engine type selected by the session manager.
///
/// These map to Rust [BackendType] variants as follows:
/// - normalAndroid → ResampledFallback (Android-managed audio via just_audio)
/// - rustOboe      → MixerBitPerfect or MixerMatched (Rust Oboe/AAudio mixer path)
/// - usbDacExperimental → UsbDirect (Rust USB direct/isochronous)
/// - dapInternalHighRes → DapNative (Rust Oboe exclusive on confirmed DAP)
enum AudioEngineType {
  normalAndroid,
  rustOboe,
  usbDacExperimental,
  dapInternalHighRes;

  bool get usesRustBackend => this != AudioEngineType.normalAndroid;

  bool get isDirectUsbExperimental =>
      this == AudioEngineType.usbDacExperimental;

  bool get isAndroidManaged => this != AudioEngineType.usbDacExperimental;

  String get backendType => switch (this) {
    AudioEngineType.normalAndroid => 'resampled_fallback',
    AudioEngineType.rustOboe => 'mixer_bit_perfect',
    AudioEngineType.usbDacExperimental => 'usb_direct',
    AudioEngineType.dapInternalHighRes => 'dap_native',
  };

  String get logLabel => switch (this) {
    AudioEngineType.normalAndroid => 'NORMAL_ANDROID',
    AudioEngineType.rustOboe => 'RUST_OBOE',
    AudioEngineType.usbDacExperimental => 'USB_DAC_EXPERIMENTAL',
    AudioEngineType.dapInternalHighRes => 'DAP_INTERNAL_HIGH_RES',
  };

  String get userFacingLabel => switch (this) {
    AudioEngineType.normalAndroid => 'just_audio / ExoPlayer',
    AudioEngineType.rustOboe => 'Rust via Oboe',
    AudioEngineType.usbDacExperimental => 'Bit-perfect (USB DAC)',
    AudioEngineType.dapInternalHighRes => 'Rust via Oboe (high-res)',
  };
}