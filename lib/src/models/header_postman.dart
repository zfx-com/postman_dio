import 'package:postman_dio/models.dart';
import 'package:postman_dio/helpers.dart';

class HeaderPostman {
  HeaderPostman({
    this.key,
    this.value,
    this.disabled = false,
    this.description,
  });

  final String key;
  final String value;
  final bool disabled;
  final DescriptionPostman description;

  HeaderPostman copyWith({
    String key,
    String value,
    bool disabled,
    DescriptionPostman description,
  }) {
    return HeaderPostman(
      key: key ?? this.key,
      value: value ?? this.value,
      disabled: disabled ?? this.disabled,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'disabled': disabled,
      'description': description?.toMap(),
    };
  }

  static HeaderPostman fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }

    return HeaderPostman(
      key: map['key']?.toString(),
      value: map['value']?.toString(),
      disabled: DartDynamic.asBool(map['disabled']),
      description:
          DescriptionPostman.fromMap(DartDynamic.asMap(map['description'])),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<HeaderPostman> fromJson(String source) async =>
      HeaderPostman.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Header(key: $key, value: $value, disabled: $disabled, description: $description)';
  }
}
