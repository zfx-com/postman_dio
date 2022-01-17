import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class ResponsePostman {
  ResponsePostman({
    this.name,
    this.originalRequest,
    this.status,
    this.code,
    this.header,
    this.cookie,
    this.body,
  });

  final String? name;
  final RequestPostman? originalRequest;
  final String? status;
  final int? code;
  final List<HeaderPostman?>? header;
  final List<dynamic>? cookie;
  final String? body;

  ResponsePostman copyWith({
    String? name,
    RequestPostman? originalRequest,
    String? status,
    int? code,
    List<HeaderPostman>? header,
    List<dynamic>? cookie,
    String? body,
  }) {
    return ResponsePostman(
      name: name ?? this.name,
      originalRequest: originalRequest ?? this.originalRequest,
      status: status ?? this.status,
      code: code ?? this.code,
      header: header ?? this.header,
      cookie: cookie ?? this.cookie,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'originalRequest': originalRequest?.toMap(),
      'status': status,
      'code': code,
      'header': header?.map((x) => x?.toMap()).toList(),
      'cookie': cookie,
      'body': body,
      '_postman_previewlanguage': 'json',
    };
  }

  static ResponsePostman? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return ResponsePostman(
      name: map['name']?.toString(),
      originalRequest: RequestPostman.fromMap(DartDynamic.asMap(map['originalRequest'])),
      status: map['status']?.toString(),
      code: map['code'] == null ? null : int.tryParse(map['code'].toString()),
      header: DartDynamic.asList(map['header'])?.map((x) => HeaderPostman.fromMap(DartDynamic.asMap(x))).toList(),
      cookie: DartDynamic.asList(map['cookie']),
      body: map['body']?.toString(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<ResponsePostman?> fromJson(String source) async => ResponsePostman.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Response(name: $name, originalRequest: $originalRequest, status: $status, code: $code, header: $header, cookie: $cookie, body: $body)';
  }
}
