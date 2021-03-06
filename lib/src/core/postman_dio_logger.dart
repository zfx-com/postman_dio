import 'package:dio/dio.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class PostmanDioLogger extends Interceptor {
  PostmanDioLogger({
    this.logPrint = print,
    this.enablePrint = false,
    this.maxMilliseconds,
  });

  // ignore: use_setters_to_change_properties
  static void changeNameCollection(String name) {
    postmanCollection.info.name = name;
  }

  static PostmanCollection postmanCollection = PostmanCollection(
    info: InfoCollection(
        name: 'PostmanDioLogger ${DateTime.now().toUtc()}', schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'),
    item: [],
  );

  final stopwatch = Stopwatch();
  final bool enablePrint;

  /// Log if the request is executed more than maxMilliseconds ms, if 'null' log all request
  final int maxMilliseconds;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  // you can override this for change your log value
  Future<String> getPrintValue(ItemPostmanRequest request) => getPrintJson(request);

  ItemPostmanRequest newRequest;

  /// JSON collection for import by the postman or another client
  static Future<String> export() async {
    return postmanCollection.toJson();
  }

  @override
  Future onRequest(RequestOptions options) async {
    try {
      stopwatch.start();
      newRequest = ItemPostmanRequest(
        name: options?.path == null ? null : options?.uri?.toString(),
        request: await RequestPostman.fromRequest(options),
      );
      postmanCollection.item.add(newRequest);
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return options;
  }

  @override
  Future onError(DioError err) async {
    try {
      _checkTime();
      newRequest ??= ItemPostmanRequest(
        name: err?.request?.path == null ? null : err?.request?.uri.toString(),
        request: await RequestPostman.fromRequest(err?.request),
      );
      newRequest
        ..name = '[${stopwatch.elapsedMilliseconds}ms] ${newRequest.name}'
        ..request = newRequest.request?.copyWith(
          description: err.toString(),
        );
      await _log();
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return err;
  }

  @override
  Future onResponse(Response response) async {
    try {
      _checkTime();
      newRequest
        ..name = '[${stopwatch.elapsedMilliseconds}ms] ${newRequest.name}'
        ..request = newRequest.request.copyWith(
          description: response?.toString(),
        )
        ..response = <ResponsePostman>[
          ResponsePostman(
            name: response?.request?.path == null ? null : response?.request?.uri?.toString(),
            code: response?.statusCode,
            status: response?.statusMessage,
            originalRequest: await RequestPostman.fromRequest(response?.request),
            body: await TransformerJson.encode(response?.data),
            header: response?.headers?.map?.keys
                ?.map((key) => HeaderPostman(
                      key: key,
                      value: response.headers[key]?.toString(),
                    ))
                ?.toList(),
          ),
        ];
      await _log();
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return response;
  }

  void _checkTime() {
    stopwatch.stop();
    if (maxMilliseconds != null) {
      if (stopwatch.elapsedMilliseconds < maxMilliseconds) {
        postmanCollection.item.remove(newRequest);
      }
    }
  }

  Future _log() async {
    if (enablePrint) {
      if (maxMilliseconds != null) {
        if (stopwatch.elapsedMilliseconds < maxMilliseconds) {
          return;
        }
      }
      logPrint(await getPrintValue(newRequest));
    }
  }

  Future<String> getPrintJson(ItemPostmanRequest request) async {
    return request?.toJson();
  }

  Future<String> getPrintSimple(ItemPostmanRequest request) async {
    return '${request?.request?.method}:${request?.response?.firstOrDefault?.code} ${request?.request?.url?.raw}';
  }
}
