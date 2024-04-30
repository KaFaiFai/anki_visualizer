import 'dart:convert';
import 'dart:io';

import 'package:anki_visualizer/core/values.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class Log {
  static final logger = Logger(
    printer: _PrinterWithTime(),
    output: _FileConsoleOutput(),
  );
}

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class _PrinterWithTime extends LogPrinter {
  static final levelPrefixes = {
    Level.trace: 'TRACE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO',
    Level.warning: 'WARN',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  _PrinterWithTime();

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = event.time.toIso8601String();
    return ['[$timeStr] ${levelPrefixes[event.level]!}: $messageStr$errorStr'];
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}

/// Outputs log messages to file and console if in debug mode
class _FileConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final file = File(join(Values.appDirectory, "log.txt"));
    if (!file.existsSync()) file.createSync(recursive: true);
    for (var line in event.lines) {
      file.writeAsStringSync("$line\n", mode: FileMode.append);
      if (kDebugMode) {
        print(line);
      }
    }
  }
}
