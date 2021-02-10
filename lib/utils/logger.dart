import 'package:logger/logger.dart';

class AppLogger {
  static final logger = Logger();

  static void logVerbose(String message) {
    logger.v(message);
  }

  static void logDebug(String message) {
    logger.d(message);
  }

  static void logInfo(String message) {
    logger.i(message);
  }

  static void logWarning(String message) {
    logger.w(message);
  }

  static void logError(String message) {
    logger.e(message);
  }

  static void logWTF(String message) {
    logger.wtf(message);
  }
}
