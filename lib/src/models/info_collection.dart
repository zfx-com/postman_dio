import 'package:postman_dio/helpers.dart';

class InfoCollection {
  InfoCollection({
    this.name,
    this.schema,
  });

  String? name;
  final String? schema;

  InfoCollection copyWith({
    String? name,
    String? schema,
  }) {
    return InfoCollection(
      name: name ?? this.name,
      schema: schema ?? this.schema,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'schema': schema,
    };
  }

  static InfoCollection? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return InfoCollection(
      name: map['name']?.toString(),
      schema: map['schema']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<InfoCollection?> fromJson(String source) async => InfoCollection.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Info(name: $name, schema: $schema)';
}
