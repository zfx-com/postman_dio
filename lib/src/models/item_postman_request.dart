import 'package:postman_dio/helpers.dart';
import 'package:postman_dio/models.dart';

class ItemPostmanRequest {
  ItemPostmanRequest({
    required this.name,
    required this.request,
    required this.stopwatch,
    this.protocolProfileBehavior,
    this.response,
  });

  String? name;
  RequestPostman? request;
  ProtocolProfileBehavior? protocolProfileBehavior;
  List<ResponsePostman>? response;
  Stopwatch stopwatch;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'request': request?.toMap(),
      'stopwatch': stopwatch.elapsedMilliseconds,
      'protocolProfileBehavior': protocolProfileBehavior?.toMap(),
      'response': response?.map((x) => x.toMap()).toList(),
    };
  }

  static ItemPostmanRequest? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return ItemPostmanRequest(
      name: map['name']?.toString(),
      request: RequestPostman.fromMap(DartDynamic.asMap(map['request'])),
      stopwatch: Stopwatch(),
      protocolProfileBehavior: ProtocolProfileBehavior.fromMap(DartDynamic.asMap(map['protocolProfileBehavior'])),
      response: List<ResponsePostman>.from(
        DartDynamic.asList(map['response'])!.map((e) => ResponsePostman.fromMap(DartDynamic.asMap(e))),
      ),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<ItemPostmanRequest?> fromJson(String source) async => ItemPostmanRequest.fromMap(await TransformerJson.decode(source));

  @override
  String toString() {
    return 'Item(name: $name, request: $request, protocolProfileBehavior: $protocolProfileBehavior, response: $response, stopwatch: ${stopwatch.elapsedMilliseconds})';
  }
}
