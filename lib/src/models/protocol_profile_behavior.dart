import 'package:postman_dio/helpers.dart';

class ProtocolProfileBehavior {
  ProtocolProfileBehavior({
    this.followRedirects,
    this.followOriginalHttpMethod,
    this.followAuthorizationHeader,
  });

  final bool followRedirects;
  final bool followOriginalHttpMethod;
  final bool followAuthorizationHeader;

  ProtocolProfileBehavior copyWith({
    bool followRedirects,
    bool followOriginalHttpMethod,
    bool followAuthorizationHeader,
  }) {
    return ProtocolProfileBehavior(
      followRedirects: followRedirects ?? this.followRedirects,
      followOriginalHttpMethod:
          followOriginalHttpMethod ?? this.followOriginalHttpMethod,
      followAuthorizationHeader:
          followAuthorizationHeader ?? this.followAuthorizationHeader,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'followRedirects': followRedirects,
      'followOriginalHttpMethod': followOriginalHttpMethod,
      'followAuthorizationHeader': followAuthorizationHeader,
    };
  }

  static ProtocolProfileBehavior fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }

    return ProtocolProfileBehavior(
      followRedirects: DartDynamic.asBool(map['followRedirects']),
      followOriginalHttpMethod:
          DartDynamic.asBool(map['followOriginalHttpMethod']),
      followAuthorizationHeader:
          DartDynamic.asBool(map['followAuthorizationHeader']),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<ProtocolProfileBehavior> fromJson(String source) async =>
      ProtocolProfileBehavior.fromMap(await TransformerJson.decode(source));

  @override
  String toString() =>
      'ProtocolProfileBehavior(followRedirects: $followRedirects, followOriginalHttpMethod: $followOriginalHttpMethod, followAuthorizationHeader: $followAuthorizationHeader)';
}
