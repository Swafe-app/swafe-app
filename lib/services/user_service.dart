import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/user/user_response_model.dart';
import 'package:swafe/models/user/user_selfie_response_model.dart';
import 'package:swafe/models/user/user_token_response_model.dart';
import 'package:swafe/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<ApiResponse<UserTokenResponse>> login(
      String email, String password) async {
    try {
      final response = await _apiService.performRequest(
        'users/login',
        method: 'POST',
        body: {
          'email': email,
          'password': password,
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<UserTokenResponse>.fromJson(
        jsonResponse,
        (data) => UserTokenResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserTokenResponse>> create(
    String email,
    String password,
    String firstName,
    String lastName,
    String? phoneNumber,
    String? phoneCountryCode,
  ) async {
    try {
      final response = await _apiService.performRequest(
        'users/create',
        method: 'POST',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'phoneCountryCode': phoneCountryCode,
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<UserTokenResponse>.fromJson(
        jsonResponse,
        (data) => UserTokenResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserTokenResponse>> getOne(String token) async {
    try {
      final response = await _apiService.performRequest(
        'users/one',
        method: 'GET',
        token: token,
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<UserTokenResponse>.fromJson(
        jsonResponse,
        (data) => UserTokenResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserResponse>> update(
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? phoneCountryCode,
  ) async {
    try {
      final response = await _apiService.performRequest(
        'users/update',
        method: 'PUT',
        token: await storage.read(key: 'token'),
        body: {
          'email': email ?? '',
          'firstName': firstName ?? '',
          'lastName': lastName ?? '',
          'phoneCountryCode': phoneCountryCode ?? '',
          'phoneNumber': phoneNumber ?? '',
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<UserResponse>.fromJson(
        jsonResponse,
        (data) => UserResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<UserResponse>> updatePassword(String password, String newPassword) async {
    try {
      final response = await _apiService.performRequest(
        'users/updatePassword',
        method: 'PUT',
        token: await storage.read(key: 'token'),
        body: {
          'password': password,
          'newPassword': newPassword,
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<UserResponse>.fromJson(
        jsonResponse,
        (data) => UserResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SelfieUserResponse>> uploadSelfie(File file) async {
    try {
      final response = await _apiService.performRequest(
        'users/upload-selfie',
        method: 'MULTIPART',
        token: await storage.read(key: 'token'),
        body: {
          'file': file,
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<SelfieUserResponse>.fromJson(
        jsonResponse,
        (data) => SelfieUserResponse.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> verifyEmail(String token) async {
    try {
      final response = await _apiService.performRequest(
        'users/verifyEmail/$token',
        method: 'GET',
        token: await storage.read(key: 'token'),
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse.fromJson(jsonResponse, (data) => data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> delete() async {
    try {
      final response = await _apiService.performRequest(
        'users/delete',
        method: 'DELETE',
        token: await storage.read(key: 'token'),
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse.fromJson(jsonResponse, (data) => data);
    } catch (e) {
      rethrow;
    }
  }
}
