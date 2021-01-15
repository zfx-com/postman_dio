import 'package:dio/dio.dart';
import 'package:postman_dio/models.dart';
import 'package:postman_dio/helpers.dart';

class RequestPostman {
  RequestPostman({
    this.method,
    this.url,
    this.description,
    this.header,
    this.body,
    this.auth,
  });

  final String method;
  final UrlPostman url;
  final String description;
  final List<HeaderPostman> header;
  final BodyPostman body;
  final AuthPostman auth;

  RequestPostman copyWith({
    String method,
    UrlPostman url,
    String description,
    List<HeaderPostman> header,
    BodyPostman body,
    AuthPostman auth,
  }) {
    return RequestPostman(
      method: method ?? this.method,
      url: url ?? this.url,
      description: description ?? this.description,
      header: header ?? this.header,
      body: body ?? this.body,
      auth: auth ?? this.auth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'url': url.toMap(),
      'description': description,
      'header': header?.map((x) => x?.toMap())?.toList(),
      'body': body?.toMap(),
      'auth': auth?.toMap(),
    };
  }

  static RequestPostman fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }

    return RequestPostman(
      method: map['method']?.toString(),
      url: UrlPostman.fromMap(DartDynamic.asMap(map['url'])),
      description: map['description']?.toString(),
      header: List<HeaderPostman>.from(DartDynamic.asList(map['header'])
          ?.map((x) => HeaderPostman.fromMap(DartDynamic.asMap(x)))),
      body: BodyPostman.fromMap(DartDynamic.asMap(map['body'])),
      auth: AuthPostman.fromMap(DartDynamic.asMap(map['auth'])),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<RequestPostman> fromJson(String source) async =>
      RequestPostman.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Request(method: $method, url: $url, description: $description, header: $header, body: $body, auth: $auth)';
  }

  static Future<RequestPostman> fromRequest(RequestOptions options) async {
    if (options == null) {
      return null;
    }
    return RequestPostman(
      method: options.method,
      url: options?.path == null ? null : UrlPostman.fromUri(options?.uri),
      body: BodyPostman(
          raw: await TransformerJson.encode(DartDynamic.asMap(options?.data))),
      header: options?.headers?.keys
          ?.map((key) => HeaderPostman(
                key: key,
                value: options.headers[key]?.toString(),
              ))
          ?.toList(),
    );
  }
}
