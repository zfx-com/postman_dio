import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class UrlPostman {
  UrlPostman({
    this.raw,
    this.query,
    this.protocol,
    this.host,
    this.port,
    this.path,
  });

  final String? raw;
  final List<QueryPostman?>? query;
  final String? protocol;
  final List<String>? host;
  final int? port;
  final List<String>? path;

  UrlPostman copyWith({
    String? raw,
    List<QueryPostman>? query,
    String? protocol,
    List<String>? host,
    int? port,
    List<String>? path,
  }) {
    return UrlPostman(
      raw: raw ?? this.raw,
      query: query ?? this.query,
      protocol: protocol ?? this.protocol,
      host: host ?? this.host,
      port: port ?? this.port,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'raw': raw,
      'query': query?.map((x) => x?.toMap()).toList(),
      'protocol': protocol,
      'host': host?.map((x) => x).toList(),
      'port': port,
      'path': path?.map((x) => x).toList(),
    };
  }

  static UrlPostman? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return UrlPostman(
      raw: map['raw']?.toString(),
      query: List<QueryPostman>.from(DartDynamic.asList(map['query'])!.map((e) => QueryPostman.fromMap(DartDynamic.asMap(e)))),
      protocol: map['protocol']?.toString(),
      host: List<String>.from(DartDynamic.asList(map['host'])!),
      path: List<String>.from(DartDynamic.asList(map['path'])!),
      port: map['port'] == null ? null : int.tryParse(map['port'].toString()),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<UrlPostman?> fromJson(String source) async => UrlPostman.fromMap(await TransformerJson.decode(source));
  static UrlPostman fromUri(Uri uri) {
    return UrlPostman(
      host: uri.host.split('.'),
      path: uri.path.split('.'),
      protocol: uri.scheme,
      port: uri.port,
      query: uri.query.split('&').map(QueryPostman.fromString).where((el) => el != null).toList(),
      raw: uri.toString(),
    );
  }

  @override
  String toString() {
    return 'Url(raw: $raw, query: $query, protocol: $protocol, host: $host, port: $port, path: $path)';
  }
}
