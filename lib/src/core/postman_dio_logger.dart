import 'package:dio/dio.dart';
import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class PostmanDioLogger extends Interceptor {
  PostmanDioLogger({
    this.logPrint = print,
    this.enabled = true,
    this.enablePrint = false,
    this.maxMilliseconds,
    this.options = const PostmanDioLoggerOptions(),
  });

  static const _extraIdKey = 'postman_request';

  // ignore: use_setters_to_change_properties
  static void changeNameCollection(String name) {
    postmanCollection.info!.name = name;
  }

  static PostmanCollection postmanCollection = PostmanCollection(
    info: InfoCollection(
      name: 'PostmanDioLogger ${DateTime.now().toUtc()}',
      schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
    ),
    item: [],
  );

  static ItemPostmanRequest? getOptionsItem(RequestOptions options) {
    final object = options.extra[_extraIdKey];
    return DartDynamic.asT<ItemPostmanRequest>(object);
  }

  /// Toggles the ability to collect data by the interceptor. Default is `true`.
  bool enabled = true;

  /// Toggles the ability to log output via the method [logPrint]
  bool enablePrint;

  /// Log if the request is executed more than maxMilliseconds ms, if 'null' log all request
  final int? maxMilliseconds;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  void Function(Object object) logPrint;

  /// Additional logger options.
  final PostmanDioLoggerOptions options;

  // you can override this for change your log value
  Future<String?>? getPrintValue(ItemPostmanRequest? request) => getPrintJson(request);

  /// JSON collection for import by the postman or another client
  static Future<String> export() async {
    return postmanCollection.toJson();
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler? handler) async {
    if (!enabled) {
      return handler?.next(options);
    }

    try {
      final item = ItemPostmanRequest(
        name: options.safeUri?.toString(),
        request: await RequestPostman.fromRequest(options),
        stopwatch: Stopwatch()..start(),
      );
      options.extra[_extraIdKey] = item;
      postmanCollection.item!.add(item);
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler? handler) async {
    if (!enabled) {
      return handler?.next(err);
    }

    try {
      final itemRequest = getOptionsItem(err.requestOptions) ??
          // unlikely to trigger
          ItemPostmanRequest(
            name: err.response?.requestOptions.path == null ? null : err.response?.requestOptions.uri.toString(),
            request: await RequestPostman.fromRequest(err.response?.requestOptions),
            stopwatch: Stopwatch()..start(),
          );
      _checkTime(itemRequest);
      itemRequest
        ..name = '[${itemRequest.stopwatch.elapsedMilliseconds}ms] ${itemRequest.name}'
        ..request = itemRequest.request?.copyWith(
          description: err.toString(),
        )
        ..response = <ResponsePostman>[
          ResponsePostman(
            name: itemRequest.name,
            code: err.response?.statusCode,
            status: err.response?.statusMessage,
            originalRequest: await RequestPostman.fromRequest(err.response?.requestOptions),
            body: err.response?.data == null ? await TransformerJson.encode(err.response?.data) : err.message,
            header: err.response?.headers.map.keys
                .map((key) => HeaderPostman(
                      key: key,
                      value: err.response?.headers[key]?.toString(),
                    ))
                .toList(),
          ),
        ];
      await _log(itemRequest);
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(err);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler? handler) async {
    if (!enabled) {
      return handler?.next(response);
    }

    try {
      final itemRequest = getOptionsItem(response.requestOptions);
      if (itemRequest != null) {
        _checkTime(itemRequest);
        itemRequest
          ..name = '[${itemRequest.stopwatch.elapsedMilliseconds}ms] ${itemRequest.name}'
          ..request = itemRequest.request?.copyWith(
            description: response.toString(),
          )
          ..response = <ResponsePostman>[
            ResponsePostman(
              name: response.requestOptions.safeUri?.toString(),
              code: response.statusCode,
              status: response.statusMessage,
              originalRequest: await RequestPostman.fromRequest(response.requestOptions),
              body: await TransformerJson.encode(response.data),
              header: response.headers.map.keys
                  .map((key) => HeaderPostman(
                        key: key,
                        value: response.headers[key]?.toString(),
                      ))
                  .toList(),
            ),
          ];
        await _log(itemRequest);
      }
    } catch (error, stackTrace) {
      l.log('$error', name: 'PostmanDioLogger', error: error, stackTrace: stackTrace);
    }
    return handler?.next(response);
  }

  Future<String?>? getPrintJson(ItemPostmanRequest? request) async {
    return request?.toJson();
  }

  Future<String> getPrintSimple(ItemPostmanRequest? request) async {
    return '${request?.request?.method}:${request?.response?.firstOrDefault?.code} ${request?.request?.url?.raw}';
  }

  void _checkTime(ItemPostmanRequest request) {
    request.stopwatch.stop();
    if (maxMilliseconds != null) {
      if (request.stopwatch.elapsedMilliseconds < maxMilliseconds!) {
        postmanCollection.item!.remove(request);
      }
    }
  }

  Future<void> _log(ItemPostmanRequest request) async {
    final requestSucceed = request.response?.firstOrDefault?.code == 200;
    if (enablePrint && ((options.printOnSuccess && requestSucceed) || (options.printOnError && !requestSucceed))) {
      if (maxMilliseconds != null) {
        if (request.stopwatch.elapsedMilliseconds < maxMilliseconds!) {
          return;
        }
      }
      logPrint(await getPrintValue(request) ?? '');
    }
  }
}

/// Additional configuration options for PostmanDioLogger.
class PostmanDioLoggerOptions {
  const PostmanDioLoggerOptions({
    this.printOnSuccess = true,
    this.printOnError = true,
  });

  /// if true, [PostmanDioLogger.logPrint] will be called on request success.
  final bool printOnSuccess;

  /// if true, [PostmanDioLogger.logPrint] will be called on request error.
  final bool printOnError;
}
