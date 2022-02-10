import 'dart:developer' as dev;

abstract class AppLogger {
  static void log(String message) {
    dev.log(message);
  }
}
