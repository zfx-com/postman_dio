import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postman_dio/postman_dio.dart';

void main() {
  test('Base process', () async {
    var postmanDioLogger = PostmanDioLogger();
    final request = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await postmanDioLogger.onRequest(request, handler);
    expect(PostmanDioLogger.postmanCollection.item!.contains(postmanDioLogger.newRequest), true);
    final response = Response(requestOptions: RequestOptions(path: ''));
    final handlerResponce = ResponseInterceptorHandler();
    await postmanDioLogger.onResponse(response, handlerResponce);
    expect(PostmanDioLogger.postmanCollection.item!.contains(postmanDioLogger.newRequest), true);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(RequestOptions(path: ''), null);
    await postmanDioLogger.onResponse(Response(requestOptions: RequestOptions(path: '')), null);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(RequestOptions(path: ''), null);
    await postmanDioLogger.onError(DioError(requestOptions: RequestOptions(path: '')), null);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(request, null);
    final dioError = DioError(requestOptions: RequestOptions(path: ''));
    await postmanDioLogger.onError(dioError, null);
    expect(PostmanDioLogger.postmanCollection.item!.contains(postmanDioLogger.newRequest), true);
  });

  test('quick', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions(path: '');
    final response = Response(requestOptions: RequestOptions(path: ''));
    final handler = RequestInterceptorHandler();
    await postmanDioLogger.onRequest(request, handler);
    final handlerResponce = ResponseInterceptorHandler();
    await postmanDioLogger.onResponse(response, handlerResponce);
    expect(PostmanDioLogger.postmanCollection.item!.contains(postmanDioLogger.newRequest), false);
  });

  test('slow', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions(path: '');
    final response = Response(requestOptions: RequestOptions(path: ''));
    await postmanDioLogger.onRequest(request, null);
    await Future.delayed(const Duration(seconds: 2));
    await postmanDioLogger.onResponse(response, null);
    expect(PostmanDioLogger.postmanCollection.item!.contains(postmanDioLogger.newRequest), true);
  });

  group('logger print options', () {
    test('do not print on request success', () async {
      var isLogPrinted = false;
      final postmanDioLogger = PostmanDioLogger(
        enablePrint: true,
        options: const PostmanDioLoggerOptions(
          printOnSuccess: false,
        ),
        logPrint: (_) => isLogPrinted = true,
      );
      final request = RequestOptions(path: '');
      final response = Response(requestOptions: RequestOptions(path: ''), statusCode: 200);
      await postmanDioLogger.onRequest(request, null);
      final handler = ResponseInterceptorHandler();
      await postmanDioLogger.onResponse(response, handler);
      if (isLogPrinted) {
        throw StateError('logPrint should not be called on request success if printOnSuccess option is false');
      }
    });
    test('do not print on request error', () async {
      var isLogPrinted = false;
      final postmanDioLogger = PostmanDioLogger(
        enablePrint: true,
        options: const PostmanDioLoggerOptions(
          printOnError: false,
        ),
        logPrint: (_) => isLogPrinted = true,
      );
      final request = RequestOptions(path: '');
      final response = Response(requestOptions: RequestOptions(path: ''), statusCode: 404);
      await postmanDioLogger.onRequest(request, null);
      final handler = ResponseInterceptorHandler();
      await postmanDioLogger.onResponse(response, handler);
      if (isLogPrinted) {
        throw StateError('logPrint should not be called on request error if printOnError option is false');
      }
    });
  });
}
