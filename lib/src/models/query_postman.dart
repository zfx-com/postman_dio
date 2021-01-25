import 'package:postman_dio/helpers.dart';

class QueryPostman {
  QueryPostman({
    this.key,
    this.value,
  });

  final String key;
  final String value;

  QueryPostman copyWith({
    String key,
    String value,
  }) {
    return QueryPostman(
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }

  static QueryPostman fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }

    return QueryPostman(
      key: map['key']?.toString(),
      value: map['value']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<QueryPostman> fromJson(String source) async => QueryPostman.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Query(key: $key, value: $value)';
  }

  static QueryPostman fromString(String e) {
    if (e == null) {
      return null;
    }
    final split = e.split('=');
    if (split.length == 2) {
      return QueryPostman(key: split[0], value: split[1]);
    }
    return null;
  }
}
