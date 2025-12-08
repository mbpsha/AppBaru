import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phoneNumber,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.register,
        data: {
          'nama': name,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'no_telepon': phoneNumber,
        },
      );

      if (response.data['token'] != null) {
        await _apiClient.setToken(response.data['token']);
      }

      return {
        'success': true,
        'message': response.data['message'] ?? 'Registration successful',
        'user': response.data['user'],
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.login,
        data: {'login': email, 'password': password},
      );

      if (response.data['token'] != null) {
        await _apiClient.setToken(response.data['token']);
      }

      return {
        'success': true,
        'message': response.data['message'] ?? 'Login successful',
        'user': response.data['user'],
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiClient.dio.post(ApiConfig.logout);
      await _apiClient.clearToken();

      return {
        'success': true,
        'message': response.data['message'] ?? 'Logout successful',
      };
    } on DioException catch (e) {
      await _apiClient.clearToken(); // Clear token even if request fails
      return _handleError(e);
    }
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.user);

      return {'success': true, 'user': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.profile);

      return {'success': true, 'user': response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? currentPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phoneNumber != null) data['no_telepon'] = phoneNumber;
      if (currentPassword != null) data['current_password'] = currentPassword;
      if (newPassword != null) data['password'] = newPassword;
      if (newPasswordConfirmation != null) {
        data['password_confirmation'] = newPasswordConfirmation;
      }

      final response = await _apiClient.dio.put(ApiConfig.profile, data: data);

      return {
        'success': true,
        'message': response.data['message'] ?? 'Profile updated successfully',
        'user': response.data['user'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handler
  Map<String, dynamic> _handleError(DioException e) {
    String message = 'An error occurred';

    if (e.response != null) {
      // Server responded with error
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;

        // Handle validation errors
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final errorMessages = errors.values
              .expand((e) => e is List ? e : [e])
              .join(', ');
          message = errorMessages;
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    return {'success': false, 'message': message, 'error': e.message};
  }
}
