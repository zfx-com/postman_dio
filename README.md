# postman_dio by zfx.com

Logger Interceptor for Dio with export to "Postman Collection v2.1".json

## Import

```dart
import 'package:postman_dio/postman_dio.dart';
```

## Change export collection

```dart
      PostmanDioLogger.changeNameCollection('MyAwesomeApp ${DateTime.now().toUtc()}');
```

## Example use

```dart
 _dio.interceptors.add(
        PostmanDioLogger(),
      );
```

## Example use for slow requests

```dart
 _dio.interceptors.add(
        PostmanDioLogger(maxMilliseconds: 1000),
      );
```

## Example use with Simple logger

```dart
 _dio.interceptors.add(
        PostmanDioLoggerSimple(
          logPrint: (Object object) => l.log(
            object.toString(),
            name: 'PostmanDioLoggerSimple',
          ),
        ),
      );
```

## Export

```dart
    final exportedCollection = await PostmanDioLogger.export();
```

### Todo:

- check not json body
- add cookie
