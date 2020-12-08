import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotoClient {
  static const String EndPoint =
      'https://asia-northeast1-keen-genius-283611.cloudfunctions.net';
  static const String Directory = '/photos';

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
