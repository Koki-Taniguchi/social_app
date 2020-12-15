import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:social_picture/models/entities/photo.dart';

class PhotoClient {
  static const String EndPoint =
      'https://asia-northeast1-keen-genius-283611.cloudfunctions.net';
  static const String Directory = '/photos';

  static Future<Map<String, dynamic>> get(double lat, double lng) async {
    try {
      final _client = http.Client();
      final _res =
          await _client.get(EndPoint + Directory + "?lat=$lat&lng=$lng");
      if (_res.statusCode != 200) {
        throw Exception("failed get $Directory");
      }

      return jsonDecode(_res.body);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  static void post(Photo photo) async {
    try {
      final Map<String, String> headers = {
        'content-encoding': 'gzip',
        'content-type': 'application/json; charset=UTF-8',
      };
      final String body = json.encode(photo.toJson());
      final List<int> zippedBody = GZipCodec().encode(body.codeUnits);
      final _client = http.Client();
      final _res = await _client.post(EndPoint + Directory,
          headers: headers, body: zippedBody);
      if (_res.statusCode != 200) {
        throw Exception("failed post $Directory");
      }
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
