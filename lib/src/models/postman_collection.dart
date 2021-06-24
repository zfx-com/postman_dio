import 'package:postman_dio/models.dart';
import 'package:postman_dio/helpers.dart';

class PostmanCollection {
  PostmanCollection({
    this.item,
    this.info,
  });
  final InfoCollection? info;
  final List<ItemPostmanRequest?>? item;

  PostmanCollection copyWith({
    InfoCollection? info,
    List<ItemPostmanRequest>? item,
  }) {
    return PostmanCollection(
      info: info ?? this.info,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'info': info?.toMap(),
      'item': item?.map((x) => x?.toMap())?.toList(),
    };
  }

  static PostmanCollection? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return PostmanCollection(
      info: InfoCollection.fromMap(DartDynamic.asMap(map['info'])),
      item: DartDynamic.asList(map['item'])?.map((x) => ItemPostmanRequest.fromMap(DartDynamic.asMap<String, dynamic>(x))).toList(),
    );
  }

  Future<String> toJson() async => TransformerJson.encode(toMap());

  static Future<PostmanCollection?> fromJson(String source) async => PostmanCollection.fromMap(await TransformerJson.decode(source));

  @override
  String toString() => 'Postman(info: $info, item: $item)';
}
