import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';

  Future<http.Response> performRequest(
    String endpoint, {
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      ...?headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      switch (method) {
        case 'POST':
          return await http.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          return await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'GET':
          return await http.get(uri, headers: headers);
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        default:
          throw UnsupportedError('Method not supported');
      }
    } catch (e) {
      rethrow;
    }
  }
}
