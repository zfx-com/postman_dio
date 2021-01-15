import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postman_dio/postman_dio.dart';

void main() {
  test('return value always', () async {
    final postmanDioLogger = PostmanDioLogger();

    final request = RequestOptions();
    expect(await postmanDioLogger.onRequest(request), request);
    expect(await postmanDioLogger.onRequest(null), null);

    final response = Response();
    expect(await postmanDioLogger.onResponse(null), null);
    expect(await postmanDioLogger.onResponse(response), response);

    final dioError = DioError();
    expect(await postmanDioLogger.onError(null), null);
    expect(await postmanDioLogger.onError(dioError), dioError);
  });
}
