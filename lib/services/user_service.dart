import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UserService {
  final String _baseUrl = "${dotenv.env['API_URL']}/users";

  Future<dynamic> createUser(String email, String password, String firstName, String lastName) async {
    print("url : ${_baseUrl}");
    final response = await http.post(
      Uri.parse("$_baseUrl/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      }),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> login(String email, String password) async {
    print("url : ${_baseUrl}");
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else{
      final result = jsonDecode(response.body);
      return result["data"];
    }
  }

  Future<dynamic> updateUser(String token,String email, String firstName, String lastName, String phoneCountryCode, String phoneNumber) async {
    print("url : ${_baseUrl}");
    final response = await http.put(
      Uri.parse("$_baseUrl/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneCountryCode': phoneCountryCode,
        'phoneNumber': phoneNumber
      }),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> updatePassword(String token, String password, String newPassword) async{
    final response = await http.put(
      Uri.parse("$_baseUrl/updatePassword"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'password': password,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> uploadSelfie(String token, File file) async {
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse("$_baseUrl/upload-selfie"));
    print(request.url);
    // Attach the file to the request
    request.files.add(
      await http.MultipartFile(
        'file', // API parameter name for the file
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last, // File name
        contentType: MediaType('image', 'jpeg'), // Path to the file
      ),
    );
    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data'; // Set content type for file upload

    // Send the request
    var streamedResponse = await request.send();

    // Get response
    var response = await http.Response.fromStream(streamedResponse);

    // Check the response
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('${response.body}');
    }
  }

  Future<dynamic> verifyEmail(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/verifyEmail/$token"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      return jsonDecode(response.body)['message'];
    }
    else {
      return jsonDecode(response.body);
    }
  }
}