import 'dart:convert';

// import 'package:computer/computer.dart';
import 'package:flutter/foundation.dart';
import 'package:postman_dio/helpers/index.dart' show DartDynamic;

class TransformerJson {
  static dynamic _decode(String text) async {
    final result = jsonDecode(text);
    return result;
  }

  static Future<Map<dynamic, dynamic>> decode(String text) async {
    if (text == null) {
      return null;
    }
    if (kIsWeb) {
      return DartDynamic.asMap(await _decode(text));
    }
    // for decode json in another thread
    // final result = await Computer().compute(_decode, param: text);
    final result = await _decode(text);
    try {
      return DartDynamic.asMap(result);
    } catch (_) {
      return null;
    }
  }

  static Future<List<dynamic>> decodeList(String text) async {
    if (text == null) {
      return null;
    }
    if (kIsWeb) {
      return DartDynamic.asList<dynamic>(await _decode(text));
    }
    // for decode json in another thread
    // final result = await Computer().compute(_decode, param: text);
    final result = await _decode(text);
    try {
      return DartDynamic.asList<dynamic>(result);
    } catch (_) {
      return null;
    }
    // return compute(_decode, text);
  }

  static Future<dynamic> decodeDynamic(String text) async {
    if (text == null) {
      return null;
    }
    if (kIsWeb) {
      return await _decode(text);
    }
    // for decode json in another thread
    // final result = await Computer().compute(_decode, param: text);
    final result = await _decode(text);
    return result;
    // return compute(_decode, text);
  }

  static String _encode(Object json) {
    return jsonEncode(json);
  }

  static Future<String> encode(Object json) async {
    if (kIsWeb) {
      return _encode(json);
    }
    // for encode json in another thread
    // return Computer().compute(_encode, param: json);
    return _encode(json);
    // return compute(_encode, json);
  }
}
