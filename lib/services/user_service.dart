import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/user/user_create_response_model.dart';
import 'package:swafe/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<dynamic> login(String email, String password) async {
    final response = await _apiService.performRequest(
      'users/login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );
    return _processResponse(response);
  }

  Future<ApiResponse<CreateUserResponse>> create(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await _apiService.performRequest(
        'users/create',
        method: 'POST',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<CreateUserResponse>.fromJson(
        jsonResponse,
        (data) => CreateUserResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getOne(String token) async {
    final response = await _apiService.performRequest(
      'users/one',
      method: 'GET',
      token: token,
    );
    return _processResponse(response);
  }

  Future<dynamic> update(String token, Map<String, dynamic> userData) async {
    final response = await _apiService.performRequest(
      'users/update',
      method: 'PUT',
      token: token,
      body: userData,
    );
    return _processResponse(response);
  }

  Future<dynamic> updatePassword(
      String token, String password, String newPassword) async {
    final response = await _apiService.performRequest(
      'users/updatePassword',
      method: 'PUT',
      token: token,
      body: {
        'password': password,
        'newPassword': newPassword,
      },
    );
    return _processResponse(response);
  }

  Future<dynamic> uploadSelfie(String token, File file) async {
    final response = await _apiService.performRequest(
      'users/uploadSelfie',
      method: 'POST',
      token: token,
      body: {
        'file': file,
      },
    );
    return _processResponse(response);
  }

  Future<dynamic> verifyEmail(String token) async {
    final response = await _apiService.performRequest(
      'users/verifyEmail/$token',
      method: 'GET',
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String token) async {
    final response = await _apiService.performRequest(
      'users/delete',
      method: 'DELETE',
      token: token,
    );
    return _processResponse(response);
  }

  dynamic _processResponse(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed: ${response.body}');
    }
  }
}
