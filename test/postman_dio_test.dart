import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postman_dio/postman_dio.dart';

void main() {
  test('Base process', () async {
    var postmanDioLogger = PostmanDioLogger();
    final request = RequestOptions();
    expect(await postmanDioLogger.onRequest(request), request);
    expect(
        PostmanDioLogger.postmanCollection.item
            .contains(postmanDioLogger.newRequest),
        true);
    final response = Response();
    expect(await postmanDioLogger.onResponse(response), response);
    expect(
        PostmanDioLogger.postmanCollection.item
            .contains(postmanDioLogger.newRequest),
        true);

    postmanDioLogger = PostmanDioLogger();
    expect(await postmanDioLogger.onRequest(null), null);
    expect(await postmanDioLogger.onResponse(null), null);

    postmanDioLogger = PostmanDioLogger();
    expect(await postmanDioLogger.onRequest(null), null);
    expect(await postmanDioLogger.onError(null), null);

    postmanDioLogger = PostmanDioLogger();
    expect(await postmanDioLogger.onRequest(request), request);
    final dioError = DioError();
    expect(await postmanDioLogger.onError(dioError), dioError);
    expect(
        PostmanDioLogger.postmanCollection.item
            .contains(postmanDioLogger.newRequest),
        true);
  });

  test('quick', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions();
    final response = Response();
    await postmanDioLogger.onRequest(request);
    await postmanDioLogger.onResponse(response);
    expect(
        PostmanDioLogger.postmanCollection.item
            .contains(postmanDioLogger.newRequest),
        false);
  });

  test('slow', () async {
    final postmanDioLogger = PostmanDioLogger(maxMilliseconds: 1000);

    final request = RequestOptions();
    final response = Response();
    await postmanDioLogger.onRequest(request);
    await Future.delayed(const Duration(seconds: 2));
    await postmanDioLogger.onResponse(response);
    expect(
        PostmanDioLogger.postmanCollection.item
            .contains(postmanDioLogger.newRequest),
        true);
  });
}
