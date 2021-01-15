import 'package:postman_dio/helpers.dart';

extension Linq<T> on List<T> {
  /// default = null
  T get firstOrDefault => isEmpty ? null : first;
}

class DartDynamic {
  // ignore: avoid_annotating_with_dynamic
  static double asDouble(dynamic value) {
    return asT<double>(value, method: 'asDouble');
  }

  // ignore: avoid_annotating_with_dynamic
  static bool asBool(dynamic value) {
    return asT<bool>(value, method: 'asBool');
  }

  // ignore: avoid_annotating_with_dynamic
  static int asInt(dynamic value) {
    return asT<int>(value, method: 'asInt');
  }

  // ignore: avoid_annotating_with_dynamic
  static Exception asException(dynamic value) {
    return asT<Exception>(value, method: 'asException');
  }

  // ignore: avoid_annotating_with_dynamic
  static DateTime asDateTime(dynamic value) {
    return asT<DateTime>(value, method: 'asDateTime');
  }

  // ignore: avoid_annotating_with_dynamic
  static List<T> asList<T>(dynamic value) {
    return asT<List<T>>(value, method: 'asList');
  }

  // ignore: avoid_annotating_with_dynamic
  static Map<K, V> asMap<K, V>(dynamic value) {
    return asT<Map<K, V>>(value, method: 'asMap');
  }

  // ignore: avoid_annotating_with_dynamic
  static Iterable<T> asIterable<T>(dynamic value) {
    return asT<Iterable<T>>(value, method: 'asIterable');
  }

  // ignore: avoid_annotating_with_dynamic
  static T asT<T>(dynamic value, {String method = 'asT'}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    l.log('Cast as exception',
        name: 'DartDynamic',
        error: Exception(
            'as for method = $method - and type = ${T.runtimeType} not applyed for $value'),
        stackTrace: StackTrace.current);
    // ignore: avoid_returning_null
    return null;
  }
}
