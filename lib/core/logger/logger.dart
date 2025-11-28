import 'dart:developer';

import 'package:flutter/foundation.dart';

mixin Logger {
  // ANSI color codes
  static const String _red = '\x1B[31m'; // Error - Red
  static const String _green = '\x1B[32m'; // Success - Green
  static const String _yellow = '\x1B[33m'; // Warning - Yellow
  static const String _blue = '\x1B[34m'; // Info - Blue
  static const String _reset = '\x1B[0m';

  void logInfo(String message) {
    if (kDebugMode) {
      log('$_blue[INFO]$_reset $message');
    }
  }

  void logError(String message) {
    if (kDebugMode) {
      log('$_red[ERROR]$_reset $message');
    }
  }

  void logSuccess(String message) {
    if (kDebugMode) {
      log('$_green[SUCCESS]$_reset $message');
    }
  }

  void logWarning(String message) {
    if (kDebugMode) {
      log('$_yellow[WARNING]$_reset $message');
    }
  }
}
