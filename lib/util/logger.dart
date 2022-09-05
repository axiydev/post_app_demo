import 'package:flutter/foundation.dart';

class Log {
  static log(Object? msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}
