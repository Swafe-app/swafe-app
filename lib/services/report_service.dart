import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final String _baseUrl = "${dotenv.env['API_URL']}/signalements";

  Future<dynamic> createReport(String token,LatLng coordinates,
      List<String> selectedDangerItems) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'coordinates': {
          'latitude': coordinates.latitude,
          'longitude': coordinates.longitude,
        },
        'selectedDangerItems': selectedDangerItems,
      }
      ),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else {
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> update(String token,LatLng coordinates,
      List<String> selectedDangerItems, String idReport) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/update/$idReport"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'coordinates': {
          'latitude': coordinates.latitude,
          'longitude': coordinates.longitude,
        },
        'selectedDangerItems': selectedDangerItems,
      }
      ),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else {
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> getList(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/list"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> getOne(String token, String reportId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/one/$reportId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> getUser(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> delete(String token, String reportId) async {
    final response = await http.delete(
      Uri.parse("$_baseUrl/delete/$reportId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }
}