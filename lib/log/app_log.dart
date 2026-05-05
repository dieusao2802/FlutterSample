import 'dart:developer' as dev;

class AppLog {
  static const String _tag = 'APP_LOG';

  /// In log thông tin bình thường
  static void info(String message) {
    _printLog('INFO', message);
  }

  /// In log cảnh báo (Warning)
  static void warning(String message) {
    _printLog('WARNING', message);
  }

  /// In log lỗi với message tùy chỉnh
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _printLog('ERROR', message, error, stackTrace);
  }

  /// Log trực tiếp đối tượng Exception hoặc Error (Không bắt buộc String message)
  static void exception(Object error, [StackTrace? stackTrace, String? message]) {
    _printLog('EXCEPTION', message ?? error.toString(), error, stackTrace);
  }

  /// Log lỗi nghiêm trọng hoặc Exception ném ra từ khối catch (Fatal)
  static void fatal(Object error, [StackTrace? stackTrace, String? message]) {
    _printLog('FATAL', message ?? error.toString(), error, stackTrace);
  }

  static void _printLog(String level, String message, [Object? error, StackTrace? stackTrace]) {
    // Lấy thông tin nơi gọi hàm (Caller)
    final stack = StackTrace.current.toString().split('\n');
    String caller = 'Unknown';
    
    // stack[2] thường là nơi gọi hàm AppLog.info/error/exception...
    if (stack.length > 2) {
      caller = _formatStackLine(stack[2]);
    }

    final String fullMessage = '[$level] [$caller] -> $message';

    dev.log(
      fullMessage,
      name: _tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Rút gọn dòng StackTrace để dễ nhìn (chỉ lấy tên file và dòng)
  static String _formatStackLine(String line) {
    // Ví dụ: #2      _MyHomePageState.initState (package:splash_sample/main.dart:60:18)
    final RegExp regExp = RegExp(r'package:.*\.dart:\d+:\d+');
    final match = regExp.firstMatch(line);
    if (match != null) {
      return match.group(0) ?? line;
    }
    return line;
  }
}
