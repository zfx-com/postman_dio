import 'package:postman_dio/models.dart';
import 'package:postman_dio/postman_dio.dart';

class PostmanDioLoggerSimple extends PostmanDioLogger {
  PostmanDioLoggerSimple({
    void Function(Object object) logPrint = print,
    bool enablePrint = true,
    PostmanDioLoggerOptions options = const PostmanDioLoggerOptions(),
  }) : super(logPrint: logPrint, enablePrint: enablePrint, options: options);
  @override
  Future<String> getPrintValue(ItemPostmanRequest? request) => getPrintSimple(request);
}
