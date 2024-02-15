import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/models/api_response_model.dart';
import 'package:swafe/models/signalement/signalement_model.dart';
import 'package:swafe/services/api_service.dart';

class SignalementService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<ApiResponse<SignalementModel>> createSignalement(
    SignalementCoordinates coordinates,
    List<SignalementDangerItemsEnum> selectedDangerItems,
  ) async {
    try {
      final response = await _apiService.performRequest(
        'signalements/create',
        method: 'POST',
        token: await storage.read(key: 'token'),
        body: {
          'coordinates': {
            'latitude': coordinates.latitude,
            'longitude': coordinates.longitude,
          },
          'selectedDangerItems': selectedDangerItems
              .map((e) => signalementDangerItemEnumToString(e))
              .toList(),
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<SignalementModel>.fromJson(
        jsonResponse,
        (data) => SignalementModel.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<SignalementModel>>> getSignalements() async {
    try {
      final response = await _apiService.performRequest(
        'signalements/list',
        method: 'GET',
        token: await storage.read(key: 'token'),
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<List<SignalementModel>>.fromJson(
        jsonResponse,
        (data) => List<SignalementModel>.from(
            data.map((e) => SignalementModel.fromJson(e))),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SignalementModel>> getSignalement(int id) async {
    try {
      final response = await _apiService.performRequest(
        'signalements/one/$id',
        method: 'GET',
        token: await storage.read(key: 'token'),
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<SignalementModel>.fromJson(
        jsonResponse,
        (data) => SignalementModel.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<SignalementModel>>> getUserSignalements() async {
    try {
      final response = await _apiService.performRequest(
        'signalements/user',
        method: 'GET',
        token: await storage.read(key: 'token'),
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<List<SignalementModel>>.fromJson(
        jsonResponse,
        (data) => List<SignalementModel>.from(
            data.map((e) => SignalementModel.fromJson(e))),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SignalementModel>> updateSignalement(
    int id,
    SignalementCoordinates? coordinates,
    List<SignalementDangerItemsEnum>? selectedDangerItems,
  ) async {
    try {
      final response = await _apiService.performRequest(
        'signalements/update/$id',
        method: 'PUT',
        token: await storage.read(key: 'token'),
        body: {
          'coordinates': coordinates != null
              ? {
                  'latitude': coordinates.latitude,
                  'longitude': coordinates.longitude,
                }
              : '',
          'selectedDangerItems': selectedDangerItems != null
              ? selectedDangerItems
                  .map((e) => signalementDangerItemEnumToString(e))
                  .toList()
              : '',
        },
      );

      dynamic jsonResponse = json.decode(response.body);
      return ApiResponse<SignalementModel>.fromJson(
        jsonResponse,
        (data) => SignalementModel.fromJson(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> deleteSignalement(int id) async {
    try {
      final response = await _apiService.performRequest(
        'signalements/delete/$id',
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
