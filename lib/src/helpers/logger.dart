import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

// ignore: camel_case_types
class l {
  static void log(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    // ignore: avoid_annotating_with_dynamic
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kIsWeb) {
      var postfix = '';
      if (error != null) {
        postfix = ', error: $error; stackTrace: $stackTrace';
      }
      // ignore: avoid_print
      print('$name: $message $postfix');
    }

    developer.log(message ?? '', name: name, error: error, stackTrace: stackTrace);
  }
}
