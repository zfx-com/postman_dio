import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postman_dio/postman_dio.dart';

void main() {
  test('Base process', () async {
    var postmanDioLogger = PostmanDioLogger();
    final request = RequestOptions(path: '');
    final handler = RequestInterceptorHandler();
    await postmanDioLogger.onRequest(request, handler);
    expect(PostmanDioLogger.postmanCollection.item.contains(postmanDioLogger.newRequest), true);
    final response = Response(requestOptions: null);
    final handlerResponce = ResponseInterceptorHandler();
    await postmanDioLogger.onResponse(response, handlerResponce);
    expect(PostmanDioLogger.postmanCollection.item.contains(postmanDioLogger.newRequest), true);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(null, null);
    await postmanDioLogger.onResponse(null, null);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(null, null);
    await postmanDioLogger.onError(null, null);

    postmanDioLogger = PostmanDioLogger();
    await postmanDioLogger.onRequest(request, null);
    final dioError = DioError(requestOptions: null);
    await postmanDioLogger.onError(dioError, null);
    expect(PostmanDioLogger.postmanCollection.item.contains(postmanDioLogger.newRequest), true);
  });

  test('quick', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions(path: '');
    final response = Response(requestOptions: null);
    final handler = RequestInterceptorHandler();
    await postmanDioLogger.onRequest(request, handler);
    final handlerResponce = ResponseInterceptorHandler();
    await postmanDioLogger.onResponse(response, handlerResponce);
    expect(PostmanDioLogger.postmanCollection.item.contains(postmanDioLogger.newRequest), false);
  });

  test('slow', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions(path: '');
    final response = Response(requestOptions: null);
    await postmanDioLogger.onRequest(request, null);
    await Future.delayed(const Duration(seconds: 2));
    await postmanDioLogger.onResponse(response, null);
    expect(PostmanDioLogger.postmanCollection.item.contains(postmanDioLogger.newRequest), true);
  });
}
