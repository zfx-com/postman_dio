import 'package:postman_dio/helpers.dart';

class BodyPostman {
  BodyPostman({
    this.mode = 'raw',
    this.disabled = false,
    this.raw,
  });

  final String? mode;
  final bool? disabled;
  final String? raw;

  BodyPostman copyWith({
    String? mode,
    bool? disabled,
    String? raw,
  }) {
    return BodyPostman(
      mode: mode ?? this.mode,
      disabled: disabled ?? this.disabled,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'disabled': disabled,
      'raw': raw,
    };
  }

  static BodyPostman? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return BodyPostman(
      mode: map['mode']?.toString(),
      disabled: DartDynamic.asBool(map['disabled']),
      raw: map['raw']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<BodyPostman?> fromJson(String source) async => BodyPostman.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Body(mode: $mode, disabled: $disabled, raw: $raw)';
}
