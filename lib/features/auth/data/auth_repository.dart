import 'package:dio/dio.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../domain/auth_models.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.authLogin,
        data: request.toJson(),
      );
      
      final data = response.data;
      if (data is Map && data['success'] == false) {
        throw data['message'] ?? 'Login failed';
      }
      
      return LoginResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    } on String catch (e) {
      throw e;
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      await _apiClient.post(
        ApiEndpoints.authChangePassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final status = e.response!.statusCode;
      final data = e.response!.data;
      
      if (status == 403) {
        return 'Access forbidden. Check your credentials.';
      }
      if (status == 401) {
        return 'Invalid username or password';
      }
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return 'Server error: $status';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check your connection.';
    }
    return 'An unexpected error occurred';
  }
}
