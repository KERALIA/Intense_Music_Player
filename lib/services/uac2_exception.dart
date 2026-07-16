enum Uac2ErrorCode {
  deviceNotFound,
  deviceBusy,
  permissionDenied,
  connectionFailed,
  transferFailed,
  unsupportedFormat,
  unknown,
}

class Uac2Exception implements Exception {
  final String message;
  final Uac2ErrorCode code;

  const Uac2Exception(this.message, this.code);

  @override
  String toString() => 'Uac2Exception: $message (code: $code)';

  factory Uac2Exception.fromMessage(String message) {
    Uac2ErrorCode code = Uac2ErrorCode.unknown;

    if (message.toLowerCase().contains('not found')) {
      code = Uac2ErrorCode.deviceNotFound;
    } else if (message.toLowerCase().contains('busy')) {
      code = Uac2ErrorCode.deviceBusy;
    } else if (message.toLowerCase().contains('permission')) {
      code = Uac2ErrorCode.permissionDenied;
    } else if (message.toLowerCase().contains('connection')) {
      code = Uac2ErrorCode.connectionFailed;
    } else if (message.toLowerCase().contains('transfer')) {
      code = Uac2ErrorCode.transferFailed;
    } else if (message.toLowerCase().contains('unsupported') ||
        message.toLowerCase().contains('format')) {
      code = Uac2ErrorCode.unsupportedFormat;
    }

    return Uac2Exception(message, code);
  }
}
