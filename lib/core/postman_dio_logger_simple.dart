import 'package:postman_dio/core/postman_dio_logger.dart';
import 'package:postman_dio/models/index.dart';

class PostmanDioLoggerSimple extends PostmanDioLogger {
  PostmanDioLoggerSimple({
    void Function(Object object) logPrint = print,
    bool enablePrint = true,
  }) : super(logPrint: logPrint, enablePrint: enablePrint);
  @override
  Future<String> getPrintValue(ItemPostmanRequest request) =>
      getPrintSimple(request);
}
