import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotoClient {
  static const String EndPoint = 'https://1ecae23e61a0.ngrok.io';
  static const String Directory = '/';

  static Future<Map<String, dynamic>> get() async {
    try {
      final _client = http.Client();
      final _res = await _client.get(EndPoint + Directory);
      if (_res.statusCode != 200) {
        throw Exception("failed get $Directory");
      }

      return jsonDecode(_res.body);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
