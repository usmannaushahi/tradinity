class CustomLogger {
  // ANSI color codes
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _blue = '\x1B[34m';

  static void log(String message, {String? color}) {
    final timestamp = DateTime.now().toIso8601String();
    String stackTraceString = "";

    if (_reset == _red) {
      stackTraceString =
          "Stack Trace : \n${StackTrace.current.toString().split('\n').take(3).join('\n')}"; // Get the first 3 lines of the stack trace
    } else {
      stackTraceString == "";
    }

    // Print colored message with stack trace
    print(
        '$color$timestamp: $message\n$stackTraceString$_reset'); // Console log
  }

  void info(String message) {
    log(message, color: _blue);
  }

  void warn(String message) {
    log('message', color: _yellow);
  }

  void error(String message) {
    log('message', color: _red);
  }

  void debug(String message) {
    log('message', color: _green);
  }
}
