import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postman_dio/postman_dio.dart';

void main() {
  group('Base process', () {
    tearDown(() {
      PostmanDioLogger.postmanCollection.item?.clear();
    });

    test('request list', () async {
      var postmanDioLogger = PostmanDioLogger();
      var request = RequestOptions(path: '');
      final handler = RequestInterceptorHandler();
      await postmanDioLogger.onRequest(request, handler);
      final requestItem = PostmanDioLogger.getOptionsItem(request);
      expect(PostmanDioLogger.postmanCollection.item!.length == 1, true);
      expect(PostmanDioLogger.postmanCollection.item!.contains(requestItem), true);

      final response = Response(requestOptions: request);
      final responseItem = PostmanDioLogger.getOptionsItem(response.requestOptions);
      expect(requestItem == responseItem, true);
      final handlerResponce = ResponseInterceptorHandler();
      await postmanDioLogger.onResponse(response, handlerResponce);
      expect(PostmanDioLogger.postmanCollection.item!.length == 1, true);
      expect(PostmanDioLogger.postmanCollection.item!.contains(responseItem), true);

      postmanDioLogger = PostmanDioLogger();
      request = RequestOptions(path: '');
      await postmanDioLogger.onRequest(request, null);
      await postmanDioLogger.onResponse(Response(requestOptions: request), null);

      postmanDioLogger = PostmanDioLogger();
      request = RequestOptions(path: '');
      await postmanDioLogger.onRequest(request, null);
      await postmanDioLogger.onError(DioError(requestOptions: request), null);

      postmanDioLogger = PostmanDioLogger();
      request = RequestOptions(path: '');
      await postmanDioLogger.onRequest(request, null);
      final dioError = DioError(requestOptions: request);
      await postmanDioLogger.onError(dioError, null);
      expect(PostmanDioLogger.postmanCollection.item!.length == 4, true);
    });

    test('quick', () async {
      final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

      final request = RequestOptions(path: '');
      final handler = RequestInterceptorHandler();
      await postmanDioLogger.onRequest(request, handler);
      final handlerResponce = ResponseInterceptorHandler();
      final response = Response(requestOptions: request);
      await postmanDioLogger.onResponse(response, handlerResponce);
      expect(PostmanDioLogger.postmanCollection.item!.isEmpty, true);
    });

    test('slow', () async {
      final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

      final request = RequestOptions(path: '');
      await postmanDioLogger.onRequest(request, null);
      await Future.delayed(const Duration(seconds: 2));
      final response = Response(requestOptions: request);
      await postmanDioLogger.onResponse(response, null);
      expect(PostmanDioLogger.postmanCollection.item!.isEmpty, false);
    });
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
      await postmanDioLogger.onRequest(request, null);
      final response = Response(requestOptions: request, statusCode: 200);
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
      await postmanDioLogger.onRequest(request, null);
      final response = Response(requestOptions: request, statusCode: 404);
      final handler = ResponseInterceptorHandler();
      await postmanDioLogger.onResponse(response, handler);
      if (isLogPrinted) {
        throw StateError('logPrint should not be called on request error if printOnError option is false');
      }
    });
  });
}
